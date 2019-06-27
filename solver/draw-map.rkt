#!/usr/bin/env racket


#lang racket

;; Utility interfaces to the low-level command
;; https://rosettacode.org/wiki/Terminal_control/Coloured_text#Racket
(define (capability? cap) (system (~a "tput "cap" > /dev/null 2>&1")))
(define (tput . xs) (system (apply ~a 'tput " " (add-between xs " "))) (void))
(define (colorterm?) (and (capability? 'setaf) (capability? 'setab)))
(define color-map '([black 0] [red 1] [green 2] [yellow 3]
                              [blue 4] [magenta 5] [cyan 6] [white 7]))
(define (foreground color) (tput 'setaf (cadr (assq color color-map))))
(define (background color) (tput 'setab (cadr (assq color color-map))))
(define (reset) (tput 'sgr0) (void))
;;;

(define (port-line-stream port)
  (stream* (read-line port) (port-line-stream port)))


(define (parse-reachable-fact reachable-fact)
  (let [(match (regexp-match #px"reachable\\((\\d+),(\\d+),(\\d+)\\)" reachable-fact))]
    (map string->number (list-tail match 1))
    ))

(define (redstone-fact? fact)
  (string-prefix? fact "reachable("))

(define (redstone-positions facts)
  (let [(reachable-facts (filter redstone-fact? facts))]
    (map parse-reachable-fact reachable-facts)))

(define (max lst [key identity])
  (if (= 1 (length lst))
      (first lst)
      (if (> (first lst) (max (list-tail lst 1)))
          (first lst)
          (max (list-tail lst 1))
          ))
  )


(define (plot-redstone positions [colors '(red )])
  (let ([width (max positions < #:key second)])
    (sort positions < #:key second)))



(define (show-redstone clingo-line)
  (letrec ([facts (string-split clingo-line " ")]
           [positions (redstone-positions facts)])
    (plot-redstone positions)
    ))


(define (main)
  (for ([line (port-line-stream (current-input-port))])
    (show-redstone line)
    ))

(define input "dim(1) dim(2) dim(3) dim(4) dim(5) dim(6) dim(7) dim(8) dim(9) dim(10) start(1,1,1) start(2,9,1) adjacent(0,-1) adjacent(0,1) adjacent(-1,0) adjacent(1,0) finish(1,5,4) finish(2,1,6) wireID(1) adjacent redstone(1,1) redstone(1,3) redstone(1,4) redstone(1,6) redstone(2,1) redstone(2,3) redstone(2,4) redstone(2,6) redstone(3,1) redstone(3,3) redstone(3,4) redstone(3,6) redstone(4,1) redstone(4,6) redstone(4,8) redstone(5,1) redstone(5,2) redstone(5,3) redstone(5,4) redstone(5,6) redstone(5,8) redstone(6,5) redstone(6,6) redstone(6,8) redstone(6,9) redstone(6,10) redstone(7,5) redstone(7,7) redstone(7,8) redstone(7,9) redstone(7,10) redstone(8,2) redstone(8,3) redstone(8,4) redstone(8,5) redstone(8,7) redstone(8,8) redstone(8,9) redstone(8,10) redstone(9,1) redstone(9,2) redstone(9,6) redstone(9,7) redstone(9,8) redstone(9,9) redstone(9,10) redstone(10,3) redstone(10,4) redstone(10,5) redstone(10,7) redstone(10,8) redstone(10,9) reachable(1,1,1) reachable(2,9,1) reachable(2,9,2) reachable(1,2,1) reachable(1,3,1) reachable(2,8,2) reachable(2,8,3) reachable(1,4,1) reachable(1,5,1) reachable(2,8,4) reachable(2,8,5) reachable(1,5,2) reachable(1,5,3) reachable(2,7,5) reachable(2,6,5) reachable(1,5,4) reachable(2,6,6) reachable(2,5,6) reachable(2,4,6) reachable(2,3,6) reachable(2,2,6) reachable(2,1,6) complete(1) complete(2)")


(show-redstone input)

;; (redstone-positions (string-split input " "))
