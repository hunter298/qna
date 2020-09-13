ThinkingSphinx::Index.define :comment, with: :active_record do
  #fields
  indexes body
  indexes user.email, as: :authord, sortable: true

  #attributes
  has commentable_type, commentable_id, user_id, created_at, updated_at
end