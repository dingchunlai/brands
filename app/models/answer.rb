class Answer < Hejia::Db::Hejia
  set_table_name "ask_zhidao_topic_posts"

  belongs_to :question, :class_name => "Question", :foreign_key => "zhidao_topic_id"
end
