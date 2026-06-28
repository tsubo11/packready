class PackingListSuggestionService
  def initialize(destination:, duration_days:)
    @destination = destination
    @duration_days = duration_days
  end

  def call
    client = Anthropic::Client.new
    response = client.messages.create(
      model: "claude-haiku-4-5",
      max_tokens: 1024,
      system: system_prompt,
      messages: [{ role: "user", content: user_prompt }]
    )
    parse_response(response)
  rescue Anthropic::Errors => e
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
        "before_departure": ["前日に準備する持ち物"],
        "day_of": ["当日朝に準備する持ち物"]
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
