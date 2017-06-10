;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname |Assignment 15|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)
;;;---------------------------------------------------------------------------------------------------
;;; DATA DEFINITIONS
(define-struct word [contents loc])

;;; A Word is (make-word Item Posn)
;;; where the contents are the word itself
;;; and loc is the position of the first letter of the word,
;;; based on a grid-coordinate system, of cell-size 15, and
;;; where x increases left->right and y increases top->bottom

#; (define (word-temp w)
     (... (word-contents w) ...
          (word-loc w)      ...))
 
(define WORD-FALLING     (make-word "veracity"  (make-posn 1   0)))
(define WORD-STATIC      (make-word "tenacious" (make-posn 1  39)))
(define WORD-STATIC-END  (make-word "flat"      (make-posn 8   0)))


;;; A [Listof X] is one of:
;;; - empty
;;; - (cons X [Listof X])

#; (define (list-temp lox)
     (cond [(empty? lox) ...]
           [(cons? lox)  ...]))

;;; A LoFW (list of falling words) is one of:
;;; - empty
;;; - (cons Word LoFW)

#; (define (lofw-temp lofw)
     (cond [(empty? lofw) ...]
           [(cons? lofw)  ...]))

(define LOFW0 empty)
(define LOFW1 (cons WORD-FALLING empty))
(define LOFW2 (list (make-word "veracity" (make-posn 1 1))
                    (make-word "flat" (make-posn 20 0))))
(define LOFW3 (list (make-word "blue" (make-posn 0 0))))

;;; A LoSW (list of static words) is one of:
;;; - empty
;;; - (cons Word LoSW)

#; (define (losw-temp losw)
     (cond [(empty? losw) ...]
           [(cons? losw)  ...]))

(define LOSW0 empty)
(define LOSW1    (cons WORD-STATIC empty))
(define LOSW2    (list (make-word "flat"      (make-posn 20 38))
                       (make-word "veracity"  (make-posn 20 39))))
(define LOSW3    (list (make-word "flat"      (make-posn 20 39))))
(define LOSW4    (list (make-word "tenacious" (make-posn 20 1))
                       (make-word "celestial" (make-posn 4   1))
                       LOSW2))
(define LOSW-END (cons WORD-STATIC-END
                       LOSW2))





(define-struct worldstate [falling static input tick-count])

;;; A WorldState (WS) is one of:
;;; - "Click to start the game"
;;; - (make-worldstate LoFW LoSW String Number)
;;; A WS represents whether or not the user has clicked to start the game
;;; If the game has started,
;;; - falling holds the list of moving words,
;;; - static holds the list of static words.
;;; - input holds the user key input
;;; - and tick-count holds the number of times the game ticks

#; (define (ws-temp ws)
     (cond [(string? ws) ...]
           [(worldstate? ws) (... (worldstate-falling ws)    ...
                                  (worldstate-static ws)     ...
                                  (worldstate-input ws)      ...
                                  (worldstate-tick-count ws) ...)]))

(define WORLD-START "Click to start the game")
(define WORLD0     (make-worldstate LOFW0 empty     ""          0))
(define WORLD1     (make-worldstate LOFW1 empty     "blue"      3))
(define WORLD2     (make-worldstate LOFW0 empty     "flat"      3))
(define WORLD3     (make-worldstate LOFW2 LOSW1     "flat"      10))
(define WORLD4     (make-worldstate LOFW3 LOSW3     "veracious" 4))
(define WORLD-END  (make-worldstate LOFW1 LOSW-END  ""          49))




;;; An Item is one of:
;;; - "veracity"
;;; - "flat"
;;; - "tenacious"
;;; - "celestial"

#; (define (item-temp i)
     (cond [(string=? i "veracity")   ...]
           [(string=? i "flat")       ...]
           [(string=? i "tenacious")  ...]
           [(string=? i "celestial")  ...]))
(define VERACITY     "veracity")
(define FLAT         "flat")
(define TENACIOUS    "tenacious")
(define CELESTIAL    "celestial")

           


;;; A Color is one of:
;;; - ACTIVE-COLOR ; 'green
;;; - TYPING-COLOR ; 'purple
;;; - STATIC-COLOR  ; 'red
;;; - SCORE-COLOR  ; 'black

#; (define (color-temp c)
     (cond [(string=? c ACTIVE-COLOR)  ...]
           [(string=? c TYPING-COLOR)  ...]
           [(string=? c STATIC-COLOR)   ...]
           [(string=? c SCORE-COLOR)   ...]))

;;;-----------------------------
;;; Constants

(define GRID-HEIGHT 40)
(define GRID-WIDTH 40)
(define CELL-SIZE 15)
(define CELL-HEIGHT CELL-SIZE)
(define CELL-WIDTH CELL-SIZE)
(define ACTIVE-COLOR "green")
(define TYPING-COLOR "purple")
(define STATIC-COLOR "red")
(define SCORE-COLOR "black")
(define SCENE-HEIGHT (* GRID-HEIGHT CELL-HEIGHT))
(define SCENE-WIDTH (* GRID-WIDTH CELL-WIDTH))
(define SCENE (empty-scene SCENE-WIDTH SCENE-HEIGHT))
(define SETTING (empty-scene (+ 100 SCENE-WIDTH) (+ 100 SCENE-WIDTH)))









;;; main: Number -> Number
;;; (main n) runs Typaholic! with tick-rate n, yielding a final score

(define (main tick)
  (* (/ 1 tick) (worldstate-tick-count (big-bang WORLD-START
                                                 [to-draw render]
                                                 [on-mouse launch]
                                                 [on-key type]
                                                 [on-tick update-world tick]
                                                 [stop-when game-over?]))))

;;;---------------------------------------------------------------------------------------------------
;;; to-draw


;;; render: WS -> Image
;;; Displays the game
(check-expect (render WORLD-START) (place-image (text "Click to start the game" 40 SCORE-COLOR)
                                                350 350
                                                (overlay SCENE
                                                         SETTING)))
(check-expect (render WORLD0)      (place-image (text "10" 15 SCORE-COLOR)
                                                675 25
                                                (overlay SCENE
                                                         SETTING)))
(check-expect (render WORLD2)      (place-image (text "40" 15 SCORE-COLOR)
                                                675 25
                                                (place-image (text "flat" 15 TYPING-COLOR)
                                                             350 675
                                                             (overlay SCENE
                                                                      SETTING))))

(define (render ws)
  (cond [(string? ws) (place-image (text ws 40 SCORE-COLOR)
                                   350 350
                                   (overlay SCENE
                                            SETTING))]
        [(worldstate? ws) (place-image (render-score
                                        (* (/ 1 .1) ;;; this (.1) represents the tick count, and
                                                    ;;; should be a variable that is the same
                                                    ;;; as the input to the function main (requiring 
                                                    ;;; ISL), or a fifth item in the worldstate,
                                                    ;;; but is unfinished. Therefore, the score
                                                    ;;; ticker only works accurately when
                                                    ;;; tick frequency = .1
                                          (+ 1 (worldstate-tick-count ws))))
                                       675 25
                                       (place-image (render-input (worldstate-input ws))
                                                    350 675
                                                    (overlay (render-all-words ws)
                                                             SETTING)))]))


;;; render-score: Number -> Image
;;; Displays the user's score
(check-expect (render-score 0)   (text "0"   15 'black))
(check-expect (render-score 1)   (text "1"   15 'black))
(check-expect (render-score 135) (text "135" 15 'black))

(define (render-score n)
  (text (number->string n) 15 SCORE-COLOR))



;;; render-input: String -> Image
;;; Displays the user's input

(check-expect (render-input "flat") (text "flat" 15 TYPING-COLOR))
(check-expect (render-input "") empty-image)
(check-expect (render-input "jamai") (text "jamai" 15 TYPING-COLOR))

(define (render-input s)
  (if (string=? "" s)
      empty-image
      (text s 15 TYPING-COLOR)))



;;; render-all-words: WS -> Image
;;; places all of the words in both lists on the scene
(check-expect (render-all-words WORLD-START) WORLD-START)
(check-expect (render-all-words WORLD0) SCENE)
(check-expect (render-all-words WORLD4)
              (place-image (text "b" 15 ACTIVE-COLOR)
                           7.5 7.5
                (place-image (text "l" 15 ACTIVE-COLOR)
                             22.5 7.5
                  (place-image (text "u" 15 ACTIVE-COLOR)
                               37.5 7.5
                    (place-image (text "e" 15 ACTIVE-COLOR)
                                 52.5 7.5
                      (place-image (text "f" 15 STATIC-COLOR)
                                   307.5 592.5
                        (place-image (text "l" 15 STATIC-COLOR)
                                     322.5 592.5
                          (place-image (text "a" 15 STATIC-COLOR)
                                       337.5 592.5
                            (place-image (text "t" 15 STATIC-COLOR)
                                         352.5 592.5
                                         SCENE)))))))))

(define (render-all-words ws)
  (cond [(string? ws) ws]
        [(worldstate? ws) (render-words (worldstate-falling ws)
                                        ACTIVE-COLOR
                                        (render-words (worldstate-static ws)
                                                      STATIC-COLOR
                                                      SCENE))]))


;;; render-words: LoW Color Image -> Image
;;; places all of the words in a list on the scene
(check-expect (render-words empty STATIC-COLOR SCENE) SCENE)
(check-expect (render-words LOFW3 ACTIVE-COLOR SCENE)
              (place-image (text "b" 15 ACTIVE-COLOR)
                           7.5 7.5
                           (place-image (text "l" 15 ACTIVE-COLOR)
                                        22.5 7.5
                                        (place-image (text "u" 15 ACTIVE-COLOR)
                                                     37.5 7.5
                                                     (place-image (text "e" 15 ACTIVE-COLOR)
                                                                  52.5 7.5
                                                                  SCENE)))))

(define (render-words low color i)
  (cond [(empty? low) i]
        [(cons? low)  (render-word (explode (word-contents (first low)))
                             (word-loc (first low))
                             (render-words (rest low) color i)
                             color)]))



;;; render-word: Lo1S(List of 1-Strings) Posn Image Color -> Image
;;; Places the letters of a word in their proper position on an image
(check-expect (render-word empty (make-posn 20 20) SCENE ACTIVE-COLOR) SCENE)
(check-expect (render-word (explode "blue") (make-posn 0 0) SCENE ACTIVE-COLOR)
              (place-image (text "b" 15 ACTIVE-COLOR)
                           7.5 7.5
                           (place-image (text "l" 15 ACTIVE-COLOR)
                                        22.5 7.5
                                        (place-image (text "u" 15 ACTIVE-COLOR)
                                                     37.5 7.5
                                                     (place-image (text "e" 15 ACTIVE-COLOR)
                                                                  52.5 7.5
                                                                  SCENE)))))
                           

(define (render-word lo1s p i color)
  (cond [(empty? lo1s) i]
        [(cons? lo1s) (place-image/grid (text (first lo1s) 15 color)
                                        (posn-x p)
                                        (posn-y p)
                                        (render-word (rest lo1s)
                                                     (make-posn (+ (posn-x p) 1) (posn-y p))
                                                     i
                                                     color))]))


;;; place-image/grid: Image Number Number Image -> Image
;;; Just like place-image, but with grid coordinates.
(check-expect (place-image/grid (text "b" 15 ACTIVE-COLOR)   0   0   SCENE)
              (place-image      (text "b" 15 ACTIVE-COLOR) 7.5 7.5   SCENE))
(check-expect (place-image/grid (text "b" 15 STATIC-COLOR)   42 42   SCENE)
              (place-image      empty-image                   0  0   SCENE))


(define (place-image/grid top x y bottom)
  (place-image top
               (* (+ x 1/2) CELL-WIDTH)
               (* (+ y 1/2) CELL-HEIGHT)
               bottom))


;;;---------------------------------------------------------------------------------------------------
;;; on-mouse

;;; launch: WS Number Number MouseEvent -> WS
;;; Starts the game on user mouse click
(check-expect (launch WORLD-START 40 5 "button-down")   WORLD0)
(check-expect (launch WORLD-START 12 4 "blue")          "Click to start the game")
(check-expect (launch WORLD0      30 9 "button-down")   WORLD0)
(check-expect (launch WORLD1      40 8 "blue")          WORLD1)

(define (launch ws x y me)
  (cond [(and (string? ws) (string=? "button-down" me)) WORLD0]
        [else ws]))

;;;---------------------------------------------------------------------------------------------------
;;; on-key


;;; type: WS KeyEvent -> WS
;;; Makes a new world with user's input
(check-expect (type WORLD-START "a") WORLD-START)
(check-expect (type WORLD0 "1") WORLD0)
(check-expect (type WORLD0 "a") (make-worldstate LOFW0 empty "a" 0))

(define (type ws ke)
  (cond [(string? ws) ws]
        [(worldstate? ws)
         (make-worldstate (type-helper (worldstate-falling ws) (worldstate-input ws) ke)
                          (worldstate-static ws)
                          (type-handler (worldstate-input ws) ke)
                          (worldstate-tick-count ws))]))


;;; type-helper: LoFW String KeyEvent -> LoFW
;;; Removes falling words when the user presses enter on an input that matches such words

(check-expect (type-helper LOFW0  "blue"      "a")   LOFW0)
(check-expect (type-helper LOFW1  "veracity"  "\r")  LOFW0)
(check-expect (type-helper LOFW1  "dog"       "\r")  LOFW1)
(check-expect (type-helper LOFW1  "veracity"  "b")   LOFW1)

(define (type-helper lofw s ke)
  (cond [(key=? "\r" ke) (if (word-in? s lofw)
                             (remove-all-words s lofw)
                             lofw)]
        [else lofw]))

;;; word-in?: String LoFW -> Boolean
;;; whether or not any words' contents in the list contain the input
(check-expect (word-in?  "veracity" LOFW1)   #true)
(check-expect (word-in?  "blue"     LOFW1)   #false)
(check-expect (word-in?  "blue"     LOFW0)   #false)
(check-expect (word-in?  "flat"     LOFW2)   #true)

(define (word-in? s lofw)
  (cond [(empty? lofw) #false]
        [(cons? lofw)  (or (string=? s (word-contents (first lofw)))
                           (word-in? s (rest lofw)))]))


;;; remove-all-words: String LoFW -> LoFW
;;; removes all instances of words that contain the input
(check-expect (remove-all-words "veracity" LOFW1)   LOFW0)
(check-expect (remove-all-words "flat"     LOFW2)   (list (make-word "veracity" (make-posn 1 1))))

(define (remove-all-words s lofw)
     (cond [(empty? lofw) empty]
           [(and (cons? lofw) (string-in? s (first lofw))) (remove-all-words s (rest lofw))]
           [else (cons (first lofw) (remove-all-words s (rest lofw)))]))

;;; string-in?: String Word -> Boolean
;;; whether or not a word contains a string
(check-expect (string-in? "veracity" WORD-FALLING) #true)
(check-expect (string-in? "blue" WORD-FALLING) #false)

(define (string-in? s w)
     (string=? (word-contents w) s))

;;; type-handler: String KeyEvent -> String
;;; Takes the user's input from keyboard

(check-expect (type-handler  ""    "4")   "")
(check-expect (type-handler  ""    "b")   "b")
(check-expect (type-handler  "ca"  "r")   "car")
(check-expect (type-handler  "car" "\b")  "ca")
(check-expect (type-handler  "car" "\r")  "")
(check-expect (type-handler  ""    "\b")  "")

(define (type-handler s ke)
  (cond [(and (= (string-length ke) 1) (string-alphabetic? ke)) (string-append s ke)]
        [(key=? ke "\b") (if (string=? "" s)
                                    s
                                    (remove-last s))]
        [(key=? ke "\r") ""]
        [else s]))



;;; remove-last: String -> String
;;; Deletes the last letter in a string

(define (remove-last s)
  (substring s 0 (- (string-length s) 1)))


;;;---------------------------------------------------------------------------------------------------
;;; on-tick

;;; update-world: WS -> WS
;;; moves the game one tick further:
;;; - moving falling words down one grid unit,
;;; - changing falling words to static,
;;; - and generating new words when necessary
(check-expect (update-world WORLD-START) WORLD-START)
(check-expect (update-world WORLD3)      (make-worldstate (list (make-word "veracity" (make-posn 1 2))
                                                                (make-word "flat" (make-posn 20 1)))
                                                          LOSW1
                                                          "flat"
                                                          11))

(define (update-world ws)
  (cond [(string? ws) ws]
        [(worldstate? ws)
         (maybe-generate-new-falling
          (make-worldstate (update-falling (worldstate-falling ws) (worldstate-static ws))
                           (update-static (worldstate-falling ws) (worldstate-static ws))
                           (worldstate-input ws)
                           (add1 (worldstate-tick-count ws))))]))


;;; update-falling: LoFW LoSW -> LoFW
;;; Moves falling words down one grid unit and removes any words about to collide with
;;; a static word or the bottom of the grid
(check-expect (update-falling LOFW1 LOSW1) (list (make-word "veracity" (make-posn 1 1))))
(check-expect (update-falling LOFW2 (list (make-word "tenacious" (make-posn 18 1))))
              (list (make-word "veracity" (make-posn 1 2))))

(define (update-falling lofw losw)
  (cond [(empty? lofw) empty]
        [(and (cons? lofw) (collide-next? (first lofw) losw))
         (update-falling (rest lofw) losw)]  
        [else (cons (move-down (first lofw))
                    (update-falling (rest lofw) losw))]))

;;; move-down: Word -> Word
;;; Moves a falling word down one grid unit
(check-expect (move-down WORD-FALLING) (make-word "veracity" (make-posn 1 1)))

(define (move-down w)
  (make-word (word-contents w)
             (make-posn (posn-x (word-loc w))
                        (add1 (posn-y (word-loc w))))))

;;; collide-next?: Word LoSW -> Boolean
;;; Is the word going to collide with a static word or the bottom of the grid?
(check-expect (collide-next? WORD-FALLING (list WORD-STATIC))                         #false)
(check-expect (collide-next? WORD-FALLING (list (make-word "blue" (make-posn 3 1))))  #true)

(define (collide-next? w losw)
  (or (= 39 (posn-y (word-loc w))) (collide-with-word? w losw)))

;;; collide-with-word?: Word LoSW -> Boolean
;;; Checks if a word collides with any words in the list
(check-expect (collide-with-word? WORD-FALLING LOSW3)    #false)
(check-expect (collide-with-word? WORD-FALLING LOSW-END) #false)
(check-expect (collide-with-word? WORD-FALLING LOSW4)    #true)


(define (collide-with-word? w losw)
  (cond [(empty? losw) #false]
        [(and (cons? losw) (right-above? w (first losw))) (or (same-x? w (first losw))
                                                              (collide-with-word? w (rest losw)))]
        [else (collide-with-word? w (rest losw))]))

;;; right-above?: Word Word -> Boolean
;;; Is the y-posn of the first word one less than the y-posn of the second word?
(check-expect (right-above? WORD-FALLING (make-word "blue" (make-posn 3 1))) #true)
(check-expect (right-above? WORD-FALLING WORD-STATIC)                        #false)

(define (right-above? w1 w2)
  (= (posn-y (word-loc w1)) (- (posn-y (word-loc w2)) 1)))


;;; same-x?: Word Word -> Boolean
;;; Do the x-posns of the words overlap?
(check-expect (same-x? WORD-FALLING WORD-STATIC)                         #true)
(check-expect (same-x? WORD-FALLING (make-word "flat" (make-posn 20 1))) #false)

(define (same-x? w1 w2)
  (compare-lists (word->lon w1) (word->lon w2)))

;;; update-static: LoFW LoSW -> LoSW
;;; Converts any falling words about to collide with a static word or the bottom of the grid
;;; into static words
(check-expect (update-static (list WORD-FALLING) (list WORD-STATIC)) (list WORD-STATIC))
(check-expect (update-static (list WORD-FALLING) (list (make-word "blue" (make-posn 3 1))))
              (list WORD-FALLING (make-word "blue" (make-posn 3 1))))


(define (update-static lofw losw)
  (cond [(empty? lofw) losw]
        [(and (cons? lofw) (collide-next? (first lofw) losw)) (cons (first lofw)
                                                                    (update-static (rest lofw) losw))]
        [else (update-static (rest lofw) losw)]))

;;; maybe-generate-new-falling : WS -> WS
;;; Maybe generate a new moving word if it's the appropriate time (tick count is even)
(check-expect (maybe-generate-new-falling WORLD-START) WORLD-START)
(check-expect (maybe-generate-new-falling WORLD2)      WORLD2)
(check-expect (worldstate? (maybe-generate-new-falling WORLD3)) #true)


(define (maybe-generate-new-falling ws)
  (cond [(string? ws) ws]
        [(worldstate? ws)
         (cond [(even? (worldstate-tick-count ws))
                (generate-new-falling/text ws (random-word (random 4)))]
               [else ws])]))

;;; random-word: Number -> Item
;;; Generates the corresponding Item given a random number
(check-expect (random-word 0) "veracity")
(check-expect (random-word 1) "flat")
(check-expect (random-word 2) "tenacious")
(check-expect (random-word 3) "celestial")


(define (random-word n)
     (cond [(= n 0)     "veracity"]
           [(= n 1)     "flat"]
           [(= n 2)     "tenacious"]
           [(= n 3)     "celestial"]))


;;; generate-new-falling/text : WS Item -> WS
;;; Generate a new falling word with this text
(check-random (generate-new-falling/text WORLD0 "veracity")
              (make-worldstate (list (make-word "veracity" (make-posn (random 33) 0))) LOSW0 "" 0))


(define (generate-new-falling/text ws i)
  (make-worldstate (cons (new-word i) (worldstate-falling ws))
                   (worldstate-static ws)
                   (worldstate-input ws)
                   (worldstate-tick-count ws)))


;;; new-word: Item -> Word
;;; Adds the item as a word at a random location at the top of the scene 
(check-random (new-word "veracity") (make-word "veracity" (make-posn (random 33) 0)))
(check-random (new-word "flat") (make-word "flat" (make-posn (random 37) 0)))
(check-random (new-word "tenacious") (make-word "tenacious" (make-posn (random 32) 0)))
(check-random (new-word "celestial") (make-word "celestial" (make-posn (random 32) 0)))


(define (new-word i)
   (cond [(string=? i "veracity")  (make-word "veracity" (make-posn (random 33) 0))]
         [(string=? i "flat")      (make-word "flat" (make-posn (random 37) 0))]
         [(string=? i "tenacious") (make-word "tenacious" (make-posn (random 32) 0))]
         [(string=? i "celestial") (make-word "celestial" (make-posn (random 32) 0))]))

;;;---------------------------------------------------------------------------------------------------
;;; stop-when
;;; game-over?: WS -> Boolean
;;; Checks if any of the static words are at the top of the scene
(check-expect (game-over? WORLD-START) #false)
(check-expect (game-over? WORLD0)      #false)
(check-expect (game-over? WORLD1)      #false)
(check-expect (game-over? WORLD4)      #false)
(check-expect (game-over? WORLD-END)   #true)

(define (game-over? ws)
  (cond [(string? ws) #false]
        [else (cond [(empty? (worldstate-falling ws)) #false]
                    [else (overlap? (first (worldstate-falling ws))
                                    (only-top-static-words (worldstate-static ws)))])]))

;;; overlap?: Word LoSW -> Boolean
;;; Does the word overlap with any of the letters of the words in the list?
(check-expect (overlap? WORD-FALLING LOSW0)                                        #false)
(check-expect (overlap? WORD-FALLING (cons WORD-STATIC-END empty))                 #true)
(check-expect (overlap? WORD-FALLING (cons (make-word "flat" (make-posn 9   0)) empty))  #false)

(define (overlap? w losw)
  (cond [(empty? losw) #false]
        [(cons? losw) (or (compare-lists (word->lon w) (word->lon (first losw)))
                          (overlap? w (rest losw)))]))

;;; compare-lists: LoN LoN -> Boolean
;;; Are any of the numbers in the lists equal?
(check-expect (compare-lists (list 1 2 3) (list 3 4 5)) #true)
(check-expect (compare-lists (list 2 3 4) (list 3 4 5)) #true)
(check-expect (compare-lists (list 1 2 3) (list 4 5 6)) #false)

(define (compare-lists lon1 lon2)
  (cond [(empty? lon1) #false]
        [(cons? lon1) (or (member? (first lon1) lon2)
                          (compare-lists (rest lon1) lon2))])) 


;;; word->lon: Word -> LoN
;;; Converts a word into the list of its letters' x positions
(check-expect (word->lon WORD-FALLING) (list 1 2 3 4 5 6 7 8))
(check-expect (word->lon (make-word "hi" (make-posn 29 0))) (list 29 30))

               
(define (word->lon w)
  (range (posn-x (word-loc w))
         (+ (string-length (word-contents w)) (posn-x (word-loc w)))
         1))



;;; only-top-static-words: LoSW -> LoS
;;; Removes all static words not at the top of the grid from the list
(check-expect (only-top-static-words LOSW0)     empty)
(check-expect (only-top-static-words LOSW3)     empty)
(check-expect (only-top-static-words LOSW-END)  (list (make-word "flat" (make-posn 8 0))))

(define (only-top-static-words losw)
  (cond [(empty? losw) empty]
        [(and (cons? losw) (top-of-grid? (first losw)))
         (cons (first losw)
               (only-top-static-words (rest losw)))]
        [else (only-top-static-words (rest losw))]))



;;; top-of-grid?: Word -> Boolean
;;; Is a word at the top of the grid?
(check-expect (top-of-grid? WORD-STATIC-END) #true)
(check-expect (top-of-grid? WORD-STATIC)     #false)


(define (top-of-grid? w)
     (= 0 (posn-y (word-loc w))))

(main .3)