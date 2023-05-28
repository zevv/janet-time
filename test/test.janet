
(use ../src/time)

#(print (time/format 1685293747 "%Y-%m-%d %H:%M:%S"))
#(print (time/format 1685293747 :iso-8601))
#(print (time/format 1685293747 :rfc-2822))
#(print (time/format 1685293747 :w3c))
#




(def tests [
  [ "%Y-%m-%d %H:%M:%S" "2023-05-28 11:19:26" 1685272766 ]
  [ "%Y%m%d%H%M%S" "20230528111926" 1685272766 ]
  [ "%d%m%y %H:%M:%S" "280523 11:44:25" 1685274265 ]
  [ "%d%m%y %I:%M:%S%p" "280523 11:48:55AM" 1685274535 ]
  [ "%Y-%m-%d %H:%M:%S" "2023-05-28 11:19:26" 1685272766 ]
  [ "%Y%m%d%H%M%S" "20230528111926" 1685272766 ]
  [ "%d%m%y %H:%M:%S" "280523 11:44:25" 1685274265 ]
])


# Formatting time

(pp (time/format 0 :iso-8601))
(pp (time/format 0 :iso-8601 "UTC"))
(pp (time/format 0 :iso-8601 "GMT"))
(pp (time/format 0 :iso-8601 "GMT+2"))


(pp (time/parse "%Y-%m-%d" "2023-05-28"))
(pp (time/parse "%Y-%m-%d" "2023-05-28" "GMT"))
(pp (time/parse "%Y-%m-%d" "2023-05-28" "CET"))
(pp (time/parse "%Y-%m-%d" "2023-05-28" "Australia/Adelaide"))
(pp (time/parse "%Y-%m-%d" "2023-05-28" "CEST"))

(doc time/format)
