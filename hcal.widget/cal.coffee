#command: "echo Hello World!"
# command: 'date -v1d +"%e"; date -v1d -v+1m -v-1d +"%d"; date +"%d%n%m%n%Y"'

dayNames: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
monthNames: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
#Su
offdayIndices: [0]

refreshFrequency: 5000
displayedDate: null

render: -> """
  <div class="container">
  <div class="title"></div>
  <table>
  <tr class="weekday"></tr>
  <tr class="midline"></tr>
  <tr class="date"></tr>
  </table>
  </div>
"""

style: """
  bottom: 45px
  font-family: -apple-system
  font-size: 14px
  font-weight: 400
  text-align: center
  color: #fff
  width: 100%

  .container
    padding: 10px

  .title
    color: rgba(#fff, .3)
    font-size: 14px
    font-weight: 500
    padding-bottom: 5px
    text-transform uppercase

  table
    border-collapse: collapse
    margin: 0 auto

  td
    padding-left: 6px
    padding-right: 6px
    text-align: center

  .weekday td
    padding-top: 3px

  .date td
    padding-bottom: 3px

  .today, .off-today
    background: rgba(#fff, 0.2)

  .weekday .today,
  .weekday .off-today
    border-radius: 3px 3px 0 0

  .date .today,
  .date .off-today
    border-radius: 0 0 3px 3px

  .midline
    height: 3px
    background: rgba(#fff, .5)

  .midline .today
    background: rgba(#0bf, .8)

  .midline .offday
    background: rgba(#f77, .5)

  .midline .off-today
    background: rgba(#fc3, .8)

  .offday, .off-today
    color: rgba(#f77, 1)
""",

update: (output, domEl) ->
  # var date = output.split("\n"), firstWeekDay = date[0], lastDate = date[1], today = date[2], m = date[3]-1, y = date[4];

  ## DON'T MANUPULATE DOM IF NOT NEEDED
  # if(this.displayedDate != null && this.displayedDate == output) return;
  # else this.displayedDate = output;

  date = new Date();
  y = date.getFullYear()
  m = date.getMonth()
  today = date.getDate()

  # DON'T MANUPULATE DOM IF NOT NEEDED
  newDate = [today, m, y].join("/")

  if this.displayedDate != null && this.displayedDate == newDate
    return
  else
    this.displayedDate = newDate

  firstWeekDay = new Date(y, m, 1).getDay()
  lastDate = new Date(y, m + 1, 0).getDate()

  weekdays = "";
  midlines = "";
  dates = "";

  i = 1
  w = firstWeekDay
  loop
    w = w%7

    isToday = (i == today)
    isOffday = (this.offdayIndices.indexOf(w) != -1)
    className = "ordinary"

    if(isToday && isOffday)
      className = "off-today"
    else if(isToday)
      className = "today"
    else if(isOffday)
      className = "offday"

    weekdays += "<td class=\""+className+"\">" + this.dayNames[w] + "</td>";
    midlines += "<td class=\""+className+"\"></td>";
    dates += "<td class=\""+className+"\">" + i + "</td>";

    w++
    i++
    break if i > lastDate

  $(domEl).find(".title").html(this.monthNames[m]+" "+y)
  $(domEl).find(".weekday").html(weekdays)
  $(domEl).find(".midline").html(midlines)
  $(domEl).find(".date").html(dates)
