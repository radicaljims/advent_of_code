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

(define (original-solution xs) (apply + (wrap-around xs)))

(require rackunit)

(define t1 "1122")
(define t2 "1111")
(define t3 "1234")
(define t4 "9121212129")

(check-equal? (original-solution (listify t1)) 3)
(check-equal? (original-solution (listify t2)) 4)
(check-equal? (original-solution (listify t3)) 0)
(check-equal? (original-solution (listify t4)) 9)

;; After looking at the task for goal 2, I decided on an alternative solution that should
;; better handle both tasks

(define (shift-list-left xs)
  (match xs
    [(list* x rest) (flatten (list* rest x))]
    [_ xs]))

(define (feedback n f xs)
  (cond
    [(> n 0) (feedback (- n 1) f (f xs))]
    [(equal? n 0) xs]))

(define (shift-list-left-n n xs) (feedback n shift-list-left xs))

(check-equal? (feedback 2 shift-list-left '(1 2 3 4)) '(3 4 1 2))
(check-equal? (feedback 4 shift-list-left '(1 2 3 4)) '(1 2 3 4))

(check-equal? (feedback 2 shift-list-left '(1 2 3 4)) (shift-list-left-n 2 '(1 2 3 4)))
(check-equal? (feedback 4 shift-list-left '(1 2 3 4)) (shift-list-left-n 4 '(1 2 3 4)))

(define (zip-solution n xs)
  (let ([sum ((curry apply) +)])
    (sum (map (λ (h1 h2) (if (equal? h1 h2) h1 0)) xs (shift-list-left-n n xs)))))

(check-equal? (original-solution (listify t1)) (zip-solution 1 (listify t1)))
(check-equal? (original-solution (listify t2)) (zip-solution 1 (listify t2)))
(check-equal? (original-solution (listify t3)) (zip-solution 1 (listify t3)))
(check-equal? (original-solution (listify t4)) (zip-solution 1 (listify t4)))

;; The statement for task 2 says all lists will have an even length, so we won't bother checking that
;; Because we are lazy
(define (zip-solution-task-2 xs)
  (let ([shift (/ (length xs) 2)])
    (zip-solution shift xs)))

(define t5 "1212")
(define t6 "1221")
(define t7 "123425")
(define t8 "123123")
(define t9 "12131415")

(check-equal? (zip-solution-task-2 (listify t5)) 6)
(check-equal? (zip-solution-task-2 (listify t6)) 0)
(check-equal? (zip-solution-task-2 (listify t7)) 4)
(check-equal? (zip-solution-task-2 (listify t8)) 12)
(check-equal? (zip-solution-task-2 (listify t9)) 4)
