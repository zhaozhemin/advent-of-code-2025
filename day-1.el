;; -*- lexical-binding: t -*-

(named-let f ((input (with-temp-buffer
                       (insert-file-contents "./day-1-input")
                       (string-split (buffer-string))))
              (start 50)
              (count 0))
  (cond ((null input) count)
        (t (let* ((direction (substring (car input) 0 1))
                  (distance (% (string-to-number (substring (car input) 1)) 100))
                  (destination (if (equal direction "L")
                                   (% (+ start (- 100 distance)) 100)
                                 (% (+ start distance) 100)))
                  (count (if (= destination 0) (+ count 1) count)))
             (f (cdr input) destination count)))))

(named-let g ((input (with-temp-buffer
                       (insert-file-contents "./day-1-input")
                       (string-split (buffer-string))))
              (start 50)
              (count 0))
  (cond ((null input) count)
        (t (let* ((direction (substring (car input) 0 1))
                  (actual-distance (string-to-number (substring (car input) 1)))
                  (distance (% actual-distance 100))
                  (laps (/ actual-distance 100)))
             (if (equal direction "L")

                 (let ((crossed-p (and (not (= start 0)) (<= (- start distance) 0))))
                   (g (cdr input) (% (+ start (- 100 distance)) 100) (if crossed-p (+ count laps 1) (+ count laps))))

               (let ((crossed-p (>= (+ start distance) 100)))
                 (g (cdr input)
                    (% (+ start distance) 100)
                    (if crossed-p (+ count laps 1) (+ count laps)))))))))
