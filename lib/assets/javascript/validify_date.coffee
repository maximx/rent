@validify_date = (val)->
  if val
    date_and_time =  val.split(' ')
    date_and_time[0] + 'T' + date_and_time[1]
  else
    val
