#lang racket

(define lines (file->lines "input.txt"))

(define (parse-line line)
  (eval (read (open-input-string line))))

(define (ator lines)
  (foldl + 0 (map parse-line lines)))

(define (the-answer) (ator lines))
