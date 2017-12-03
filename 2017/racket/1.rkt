#lang racket

(define (sum-next xs)
  (match xs
    ;; I wonder if I can combine `list-rest` and/or `match-let` to make this work
    ;; Then I could get rid of `wrap-around`
    ;; [(list x _ ... x) (list* x )]
    [(list* x x y)    (list* x (sum-next (list* x y)))]
    [(list* x y)      (sum-next y)]
    [_                (list)]))

(define (wrap-around-helper xs reps)
  (match xs
    [(list x _ ... x) (list* x reps)]
    [_ reps]))

(define (wrap-around xs) (wrap-around-helper xs (sum-next xs)))

(define (listify s)
  (map string->number (map ((curry make-string) 1) (string->list s))))

(define (solution xs) (apply + (wrap-around xs)))

(define t1 "1122")
(define t2 "1111")
(define t3 "1234")
(define t4 "9121212129")

(require rackunit)

(check-equal? (solution (listify t1)) 3)
(check-equal? (solution (listify t2)) 4)
(check-equal? (solution (listify t3)) 0)
(check-equal? (solution (listify t4)) 9)
