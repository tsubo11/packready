# 旅行先と宿泊日数をもとにAnthropicAPIへリクエストを送り、タイミング別持ち物リストを返すサービスクラス
class PackingListSuggestionService
  MODEL = "claude-haiku-4-5".freeze
  MAX_TOKENS = 1024

  def self.call(destination:, duration_days:)
    new(destination:, duration_days:).call
  end

  def initialize(destination:, duration_days:)
    @destination = destination
    @duration_days = duration_days
    @client = Anthropic::Client.new
  end

  def call
    response = @client.messages.create(
      model: MODEL,
      max_tokens: MAX_TOKENS,
      system: system_prompt,
      messages: [{ role: "user", content: user_prompt }]
    )
    parse_response(response)
  rescue Anthropic::Errors::ApiError => e
    Rails.logger.error("Anthropic API error: #{e.message}")
    nil
  end

  private

  def system_prompt
    <<~PROMPT
      あなたは旅行の持ち物リスト提案アシスタントです。
      ユーザーの旅行先と宿泊日数に基づいて、持ち物リストをJSON形式で返してください。
      必ず以下のJSON形式のみで返してください。余分なテキストは不要です。
      {
        "day_before": ["前日に準備する持ち物"],
        "morning": ["当日朝に準備する持ち物"]
      }
    PROMPT
  end

  def user_prompt
    "旅行先：#{@destination}、宿泊日数：#{@duration_days}泊"
  end

  def parse_response(response)
    text = response.content.first.text
    clean_text = text.gsub(/```json\n?/, "").gsub('```', "").strip
    JSON.parse(clean_text)
  rescue JSON::ParserError => e
    Rails.logger.error("JSON parse error: #{e.message}")
    nil
  end
end
