class Question < Hejia::Db::Hejia
  set_table_name "ask_zhidao_topics"

  belongs_to :user, :foreign_key => "user_id", :class_name => "HejiaUserBbs"
  has_many   :answers, :class_name => "Answer", :foreign_key => "zhidao_topic_id"

  def best_answer
    Answer.find(best_post_id)
  end

  def first_answer
    answers.first
  end
end
