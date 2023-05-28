
(use ../src/time)

# Test if the real time clock is running and that the time
# set to may 28 2023 or later.
(def t1 (time/now))
(ev/sleep 0.1)
(def t2 (time/now))
(assert (> t1 1685300844))
(assert (> (- t2 t1) 0.09))

# Monotic clock should always increase
(def t1 (time/monotonic))
(ev/sleep 0.1)
(def t2 (time/monotonic))
(assert (> (- t2 t1) 0.09))

# CPU time should hardly increase during sleep
(def t1 (time/cputime))
(ev/sleep 0.1)
(def t2 (time/cputime))
(assert (< (- t2 t1) 0.05))



# Conversion from time to datetime

(assert (deep= (time/to-datetime 1685300844 "GMT")
               {:dst false :hours 19 :minutes 7 :month 4 :month-day 27 :seconds 24 :week-day 0 :year 2023 :year-day 147}))

(assert (deep= (time/to-datetime 1685300844 "Australia/Adelaide")
               {:dst false :hours 4 :minutes 37 :month 4 :month-day 28 :seconds 24 :week-day 1 :year 2023 :year-day 148}))


# Conversion from datetime to time

(assert (= 1685300844 (time/from-datetime 
                 {:dst false :hours 19 :minutes 7 :month 4 :month-day 27 :seconds 24 :week-day 0 :year 2023 :year-day 147}
                 "GMT")))

(assert (= 1685300844 (time/from-datetime 
               {:dst false :hours 4 :minutes 37 :month 4 :month-day 28 :seconds 24 :week-day 1 :year 2023 :year-day 148}
               "Australia/Adelaide")))


# Formatting

(def tests [
  [1685301229 "%Y-%m-%d %H:%M:%S" "UTC"  "2023-05-28 19:13:49"]
  [1685301744 "%Y-%m-%d %H:%M:%S" "Australia/Adelaide" "2023-05-29 04:52:24"]
])

(each [t fmt tz result] tests
  (assert (= (time/format t fmt tz) result)))


# Parsing

(each [t fmt tz result] tests
  (assert (= (time/parse fmt result tz) t)))
