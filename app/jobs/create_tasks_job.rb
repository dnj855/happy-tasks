class CreateTasksJob < ApplicationJob
  queue_as :default

  def perform(children)
    @children = children
    @children.each do |child|
      chatgpt_response = client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: children_formatted_for_openai
        }
      )
    end
    new_content = chatgpt_response["choices"][0]["message"]["content"]
    # Do something later
  end

  private
  
  def client
    @client ||= OpenAI::Client.new
  end

  def children_formatted_for_openai
    results = []
    results << { role: "system", content: "Tu es spécialiste en psychologie comportementale, expert des travaux du psychologue américain Barkley et notamment de sa méthode pour faciliter la vie quotidienne des familles. Ta réponse devra consister en un objet JSON, sans aucun texte introductif ou conclusif, sur le format suivant"}
  end

end
