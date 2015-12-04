@validify_date = (val)->
  date_and_time =  val.split(' ')
  if date_and_time.length > 1
    date_and_time[0] + 'T' + date_and_time[1]
  else
    val
