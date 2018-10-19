json.array! @sessions_within_timeframe do |s|
  json.user_id s.user.id
  json.nick s.user.nickname
  json.total_time s.total_time
  json.score seconds_to_score(s.total_time)
  json.active user_active? s.user
end
