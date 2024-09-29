;shade(10) result, color for the inner 'far' side of the Fuji
shade10	equ	$226

;Colors for the middle bar
barcolors:
	dc.w	$22a,$22a,$22a,$22c,$22c,$22e,$04e,$06e
	dc.w	$06e,$08e,$0ae,$08e,$08e,$06e,$04e,$04e
	dc.w	$22e,$22e,$22c,$22c,$22a,$22a,$22a,$228
	dc.w	$226,$006,$006,$006,$006,$226,$226,$228

;Colors for the various Fuji views, 72 lines per view
fujicolors:
	dc.w	$04e,$04e,$04e,$04e,$04e,$04e,$04e,$04e
	dc.w	$04e,$04e,$04e,$04e,$04e,$04e,$04e,$04e
	dc.w	$04e,$04e,$04e,$04e,$04e,$04e,$04e,$04e
	dc.w	$04e,$04e,$04e,$04e,$04e,$04e,$04e,$04e
	dc.w	$04e,$04e,$04e,$04e,$04e,$04e,$04e,$04e
	dc.w	$04e,$04e,$04e,$04e,$04e,$04e,$04e,$04e
	dc.w	$04e,$04e,$22e,$22e,$22e,$22e,$22e,$22e
	dc.w	$22c,$22c,$22a,$22a,$228,$04e,$04e,$04e
	dc.w	$04e,$04e,$04e,$04e,$04e,$04e,$04e,$04e

	dc.w	$06e,$06e,$06e,$06e,$06e,$06e,$06e,$06e
	dc.w	$06e,$06e,$06e,$06e,$06e,$06e,$06e,$06e
	dc.w	$06e,$06e,$06e,$06e,$06e,$06e,$06e,$06e
	dc.w	$06e,$06e,$06e,$06e,$06e,$06e,$06e,$06e
	dc.w	$06e,$06e,$06e,$06e,$06e,$06e,$06e,$06e
	dc.w	$06e,$06e,$06e,$06e,$06e,$06e,$06e,$06e
	dc.w	$06e,$04e,$04e,$04e,$04e,$04e,$04e,$22e
	dc.w	$22e,$22c,$22c,$22a,$228,$06e,$06e,$06e
	dc.w	$06e,$06e,$06e,$06e,$06e,$06e,$06e,$06e

	dc.w	$08e,$08e,$08e,$08e,$08e,$08e,$08e,$08e
	dc.w	$08e,$08e,$08e,$08e,$08e,$08e,$08e,$08e
	dc.w	$08e,$08e,$08e,$08e,$08e,$08e,$08e,$08e
	dc.w	$08e,$08e,$08e,$08e,$08e,$08e,$08e,$08e
	dc.w	$08e,$08e,$08e,$08e,$08e,$08e,$08e,$08e
	dc.w	$08e,$08e,$08e,$08e,$08e,$06e,$06e,$06e
	dc.w	$06e,$06e,$06e,$06e,$06e,$06e,$04e,$04e
	dc.w	$22e,$22e,$22c,$22a,$228,$08e,$08e,$08e
	dc.w	$08e,$08e,$08e,$08e,$08e,$08e,$08e,$08e

	dc.w	$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae
	dc.w	$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae
	dc.w	$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae
	dc.w	$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae
	dc.w	$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae
	dc.w	$0ae,$0ae,$0ae,$08e,$08e,$08e,$08e,$08e
	dc.w	$08e,$08e,$08e,$06e,$06e,$06e,$06e,$04e
	dc.w	$04e,$22e,$22c,$22c,$228,$0ae,$0ae,$0ae
	dc.w	$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae

	dc.w	$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae
	dc.w	$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae
	dc.w	$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae
	dc.w	$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae
	dc.w	$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae
	dc.w	$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae
	dc.w	$0ae,$0ae,$08e,$08e,$08e,$06e,$06e,$06e
	dc.w	$04e,$04e,$22e,$22c,$228,$2ae,$2ae,$2ae
	dc.w	$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae

	dc.w	$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce
	dc.w	$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce
	dc.w	$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce
	dc.w	$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce
	dc.w	$4ce,$4ce,$4ce,$2ae,$2ae,$2ae,$2ae,$2ae
	dc.w	$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae
	dc.w	$0ae,$0ae,$0ae,$0ae,$08e,$08e,$08e,$06e
	dc.w	$06e,$04e,$22e,$22c,$228,$4ce,$4ce,$4ce
	dc.w	$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce

	dc.w	$6ce,$6ce,$6ce,$6ce,$6ce,$6ce,$6ce,$6ce
	dc.w	$6ce,$6ce,$6ce,$6ce,$6ce,$6ce,$6ce,$6ce
	dc.w	$6ce,$6ce,$6ce,$6ce,$6ce,$6ce,$6ce,$6ce
	dc.w	$6ce,$6ce,$6ce,$6ce,$6ce,$6ce,$6ce,$6ce
	dc.w	$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce
	dc.w	$4ce,$4ce,$4ce,$4ce,$2ae,$2ae,$2ae,$2ae
	dc.w	$2ae,$2ae,$0ae,$0ae,$0ae,$0ae,$08e,$06e
	dc.w	$06e,$04e,$22e,$22c,$228,$6ce,$6ce,$6ce
	dc.w	$6ce,$6ce,$6ce,$6ce,$6ce,$6ce,$6ce,$6ce

	dc.w	$8ee,$8ee,$8ee,$8ee,$8ee,$8ee,$8ee,$8ee
	dc.w	$8ee,$8ee,$8ee,$8ee,$8ee,$8ee,$8ee,$8ee
	dc.w	$8ee,$8ee,$8ee,$8ee,$8ee,$8ee,$8ee,$8ee
	dc.w	$6ee,$6ee,$6ee,$6ee,$6ee,$6ee,$6ee,$6ee
	dc.w	$6ee,$6ee,$6ee,$6ce,$6ce,$6ce,$6ce,$6ce
	dc.w	$6ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce
	dc.w	$2ae,$2ae,$2ae,$2ae,$0ae,$0ae,$08e,$08e
	dc.w	$06e,$06e,$04e,$22c,$228,$8ee,$8ee,$8ee
	dc.w	$8ee,$8ee,$8ee,$8ee,$8ee,$8ee,$8ee,$8ee

	dc.w	$aee,$aee,$aee,$aee,$aee,$aee,$aee,$aee
	dc.w	$aee,$aee,$aee,$aee,$aee,$aee,$aee,$aee
	dc.w	$cee,$cee,$cee,$aee,$aee,$aee,$aee,$aee
	dc.w	$aee,$aee,$aee,$aee,$aee,$aee,$8ee,$8ee
	dc.w	$8ee,$8ee,$8ee,$6ee,$6ee,$6ee,$6ee,$6ee
	dc.w	$6ce,$6ce,$6ce,$6ce,$4ce,$4ce,$4ce,$4ce
	dc.w	$4ce,$2ae,$2ae,$2ae,$2ae,$0ae,$0ae,$08e
	dc.w	$06e,$06e,$04e,$22c,$228,$aee,$aee,$aee
	dc.w	$aee,$aee,$aee,$aee,$aee,$aee,$aee,$aee

	dc.w	$cee,$cee,$cee,$cee,$cee,$cee,$cee,$cee
	dc.w	$cee,$cee,$cee,$cee,$cee,$cee,$cee,$cee
	dc.w	$cee,$cee,$cee,$cee,$cee,$cee,$cee,$cee
	dc.w	$cee,$cee,$cee,$cee,$cee,$cee,$aee,$aee
	dc.w	$aee,$aee,$aee,$8ee,$8ee,$8ee,$8ee,$6ee
	dc.w	$6ee,$6ee,$6ce,$6ce,$6ce,$6ce,$4ce,$4ce
	dc.w	$4ce,$4ce,$2ae,$2ae,$2ae,$0ae,$0ae,$08e
	dc.w	$08e,$06e,$04e,$22c,$228,$cee,$cee,$cee
	dc.w	$cee,$cee,$cee,$cee,$cee,$cee,$cee,$cee

	dc.w	$eee,$eee,$eee,$eee,$eee,$eee,$eee,$eee
	dc.w	$eee,$eee,$eee,$eee,$eee,$eee,$eee,$eee
	dc.w	$eee,$eee,$eee,$eee,$eee,$cee,$cee,$cee
	dc.w	$cee,$cee,$cee,$cee,$cee,$cee,$cee,$cee
	dc.w	$aee,$aee,$aee,$aee,$aee,$8ee,$8ee,$8ee
	dc.w	$6ee,$6ee,$6ee,$6ce,$6ce,$6ce,$6ce,$4ce
	dc.w	$4ce,$4ce,$4ce,$2ae,$2ae,$0ae,$0ae,$08e
	dc.w	$08e,$06e,$04e,$22c,$228,$eee,$eee,$eee
	dc.w	$eee,$eee,$eee,$eee,$eee,$eee,$eee,$eee

	dc.w	$cee,$cee,$cee,$cee,$cee,$cee,$cee,$cee
	dc.w	$cee,$cee,$cee,$cee,$cee,$cee,$cee,$cee
	dc.w	$cee,$cee,$cee,$cee,$cee,$cee,$cee,$cee
	dc.w	$cee,$cee,$cee,$cee,$cee,$cee,$cee,$aee
	dc.w	$aee,$aee,$aee,$aee,$8ee,$8ee,$8ee,$8ee
	dc.w	$6ee,$6ee,$6ee,$6ce,$6ce,$6ce,$6ce,$4ce
	dc.w	$4ce,$4ce,$4ce,$2ae,$2ae,$2ae,$0ae,$08e
	dc.w	$08e,$06e,$04e,$22e,$228,$cee,$cee,$cee
	dc.w	$cee,$cee,$cee,$cee,$cee,$cee,$cee,$cee

	dc.w	$cee,$cee,$cee,$cee,$cee,$cee,$cee,$cee
	dc.w	$cee,$cee,$cee,$cee,$cee,$cee,$cee,$cee
	dc.w	$cee,$cee,$cee,$cee,$cee,$cee,$cee,$cee
	dc.w	$aee,$aee,$aee,$aee,$aee,$aee,$aee,$aee
	dc.w	$aee,$8ee,$8ee,$8ee,$8ee,$8ee,$6ee,$6ee
	dc.w	$6ee,$6ee,$6ce,$6ce,$6ce,$6ce,$4ce,$4ce
	dc.w	$4ce,$4ce,$4ce,$2ae,$2ae,$0ae,$0ae,$08e
	dc.w	$08e,$06e,$04e,$22c,$228,$cee,$cee,$cee
	dc.w	$cee,$cee,$cee,$cee,$cee,$cee,$cee,$cee

	dc.w	$8ee,$8ee,$8ee,$8ee,$8ee,$8ee,$8ee,$8ee
	dc.w	$8ee,$8ee,$8ee,$8ee,$8ee,$8ee,$8ee,$8ee
	dc.w	$aee,$aee,$8ee,$8ee,$8ee,$8ee,$8ee,$8ee
	dc.w	$8ee,$8ee,$8ee,$8ee,$8ee,$8ee,$8ee,$8ee
	dc.w	$6ee,$6ee,$6ee,$6ee,$6ee,$6ee,$6ee,$6ce
	dc.w	$6ce,$6ce,$6ce,$6ce,$6ce,$4ce,$4ce,$4ce
	dc.w	$4ce,$4ce,$2ae,$2ae,$2ae,$0ae,$0ae,$08e
	dc.w	$08e,$06e,$04e,$22c,$228,$8ee,$8ee,$8ee
	dc.w	$8ee,$8ee,$8ee,$8ee,$8ee,$8ee,$8ee,$8ee

	dc.w	$6ee,$6ee,$6ee,$6ee,$6ee,$6ee,$6ee,$6ee
	dc.w	$6ee,$6ee,$6ee,$6ee,$6ee,$6ee,$6ee,$6ee
	dc.w	$6ee,$6ee,$6ee,$6ee,$6ee,$6ee,$6ee,$6ee
	dc.w	$6ee,$6ee,$6ee,$6ee,$6ee,$6ee,$6ee,$6ce
	dc.w	$6ce,$6ce,$6ce,$6ce,$6ce,$6ce,$6ce,$6ce
	dc.w	$6ce,$6ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce
	dc.w	$4ce,$2ae,$2ae,$2ae,$2ae,$0ae,$0ae,$08e
	dc.w	$06e,$06e,$04e,$22c,$228,$6ee,$6ee,$6ee
	dc.w	$6ee,$6ee,$6ee,$6ee,$6ee,$6ee,$6ee,$6ee

	dc.w	$6ce,$6ce,$6ce,$6ce,$6ce,$6ce,$6ce,$6ce
	dc.w	$6ce,$6ce,$6ce,$6ce,$6ce,$6ce,$6ce,$6ce
	dc.w	$6ce,$6ce,$6ce,$6ce,$6ce,$6ce,$6ce,$6ce
	dc.w	$6ce,$6ce,$6ce,$6ce,$6ce,$6ce,$6ce,$6ce
	dc.w	$6ce,$6ce,$6ce,$4ce,$4ce,$4ce,$4ce,$4ce
	dc.w	$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce
	dc.w	$2ae,$2ae,$2ae,$2ae,$0ae,$0ae,$08e,$08e
	dc.w	$06e,$06e,$04e,$22c,$228,$6ce,$6ce,$6ce
	dc.w	$6ce,$6ce,$6ce,$6ce,$6ce,$6ce,$6ce,$6ce

	dc.w	$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce
	dc.w	$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce
	dc.w	$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce
	dc.w	$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce
	dc.w	$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce
	dc.w	$4ce,$4ce,$4ce,$4ce,$2ae,$2ae,$2ae,$2ae
	dc.w	$2ae,$2ae,$0ae,$0ae,$0ae,$0ae,$08e,$06e
	dc.w	$06e,$04e,$22e,$22c,$228,$4ce,$4ce,$4ce
	dc.w	$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce

	dc.w	$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae
	dc.w	$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae
	dc.w	$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce,$4ce
	dc.w	$4ce,$4ce,$4ce,$4ce,$2ae,$2ae,$2ae,$2ae
	dc.w	$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae
	dc.w	$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae
	dc.w	$0ae,$0ae,$0ae,$0ae,$08e,$08e,$08e,$06e
	dc.w	$06e,$04e,$22e,$22c,$228,$2ae,$2ae,$2ae
	dc.w	$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae

	dc.w	$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae
	dc.w	$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae
	dc.w	$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae
	dc.w	$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae
	dc.w	$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae,$2ae
	dc.w	$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae
	dc.w	$0ae,$0ae,$08e,$08e,$08e,$06e,$06e,$06e
	dc.w	$04e,$04e,$22e,$22c,$228,$0ae,$0ae,$0ae
	dc.w	$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae

	dc.w	$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae
	dc.w	$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae
	dc.w	$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae
	dc.w	$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae
	dc.w	$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae
	dc.w	$0ae,$0ae,$0ae,$08e,$08e,$08e,$08e,$08e
	dc.w	$08e,$08e,$08e,$06e,$06e,$06e,$06e,$04e
	dc.w	$04e,$22e,$22c,$22c,$228,$0ae,$0ae,$0ae
	dc.w	$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae,$0ae

	dc.w	$08e,$08e,$08e,$08e,$08e,$08e,$08e,$08e
	dc.w	$08e,$08e,$08e,$08e,$08e,$08e,$08e,$08e
	dc.w	$08e,$08e,$08e,$08e,$08e,$08e,$08e,$08e
	dc.w	$08e,$08e,$08e,$08e,$08e,$08e,$08e,$08e
	dc.w	$08e,$08e,$08e,$08e,$08e,$08e,$08e,$08e
	dc.w	$08e,$08e,$08e,$08e,$08e,$06e,$06e,$06e
	dc.w	$06e,$06e,$06e,$06e,$06e,$06e,$04e,$04e
	dc.w	$22e,$22e,$22c,$22a,$228,$08e,$08e,$08e
	dc.w	$08e,$08e,$08e,$08e,$08e,$08e,$08e,$08e

	dc.w	$06e,$06e,$06e,$06e,$06e,$06e,$06e,$06e
	dc.w	$06e,$06e,$06e,$06e,$06e,$06e,$06e,$06e
	dc.w	$06e,$06e,$06e,$06e,$06e,$06e,$06e,$06e
	dc.w	$06e,$06e,$06e,$06e,$06e,$06e,$06e,$06e
	dc.w	$06e,$06e,$06e,$06e,$06e,$06e,$06e,$06e
	dc.w	$06e,$06e,$06e,$06e,$06e,$06e,$06e,$06e
	dc.w	$06e,$04e,$04e,$04e,$04e,$04e,$04e,$22e
	dc.w	$22e,$22c,$22c,$22a,$228,$06e,$06e,$06e
	dc.w	$06e,$06e,$06e,$06e,$06e,$06e,$06e,$06e

	dc.w	$04e,$04e,$04e,$04e,$04e,$04e,$04e,$04e
	dc.w	$04e,$04e,$04e,$04e,$04e,$04e,$04e,$04e
	dc.w	$04e,$04e,$04e,$04e,$04e,$04e,$04e,$04e
	dc.w	$04e,$04e,$04e,$04e,$04e,$04e,$04e,$04e
	dc.w	$04e,$04e,$04e,$04e,$04e,$04e,$04e,$04e
	dc.w	$04e,$04e,$04e,$04e,$04e,$04e,$04e,$04e
	dc.w	$04e,$04e,$22e,$22e,$22e,$22e,$22e,$22e
	dc.w	$22c,$22c,$22a,$22a,$228,$04e,$04e,$04e
	dc.w	$04e,$04e,$04e,$04e,$04e,$04e,$04e,$04e

	dc.w	$22c,$22c,$22c,$22c,$22c,$22c,$22c,$22c
	dc.w	$22c,$22c,$22c,$22c,$22c,$22c,$22c,$22c
	dc.w	$22e,$22e,$22e,$22e,$22e,$22e,$22e,$22e
	dc.w	$22e,$22e,$22e,$22e,$22e,$22e,$22e,$22e
	dc.w	$22e,$22e,$22e,$22e,$22e,$22e,$22e,$22e
	dc.w	$22e,$22e,$22e,$22e,$22e,$22e,$22e,$22e
	dc.w	$22e,$22e,$22e,$22c,$22c,$22c,$22c,$22c
	dc.w	$22c,$22a,$22a,$22a,$228,$22c,$22c,$22c
	dc.w	$22c,$22c,$22c,$22c,$22c,$22c,$22c,$22c

	dc.w	$22a,$22a,$22a,$22a,$22a,$22a,$22a,$22a
	dc.w	$22a,$22a,$22a,$22a,$22a,$22a,$22a,$22a
	dc.w	$22a,$22a,$22a,$22a,$22a,$22a,$22a,$22a
	dc.w	$22a,$22a,$22c,$22c,$22c,$22c,$22c,$22c
	dc.w	$22c,$22c,$22c,$22c,$22c,$22c,$22c,$22c
	dc.w	$22c,$22c,$22c,$22c,$22c,$22c,$22c,$22c
	dc.w	$22c,$22c,$22c,$22c,$22c,$22a,$22a,$22a
	dc.w	$22a,$22a,$22a,$22a,$228,$22a,$22a,$22a
	dc.w	$22a,$22a,$22a,$22a,$22a,$22a,$22a,$22a

	dc.w	$006,$006,$006,$006,$006,$006,$006,$006
	dc.w	$006,$006,$006,$006,$006,$006,$006,$006
	dc.w	$006,$006,$006,$006,$006,$006,$006,$006
	dc.w	$006,$006,$006,$006,$006,$006,$006,$006
	dc.w	$006,$006,$006,$006,$006,$006,$006,$006
	dc.w	$006,$006,$006,$006,$006,$006,$006,$006
	dc.w	$006,$006,$006,$006,$006,$006,$006,$006
	dc.w	$006,$006,$226,$226,$228,$006,$006,$006
	dc.w	$006,$006,$006,$006,$006,$006,$006,$006

	dc.w	$006,$006,$006,$006,$006,$006,$006,$006
	dc.w	$006,$006,$006,$006,$006,$006,$006,$006
	dc.w	$006,$006,$006,$006,$006,$006,$006,$006
	dc.w	$006,$006,$006,$006,$006,$006,$006,$006
	dc.w	$006,$006,$006,$006,$006,$006,$006,$006
	dc.w	$006,$006,$006,$006,$006,$006,$006,$006
	dc.w	$006,$006,$006,$006,$006,$006,$006,$006
	dc.w	$226,$226,$226,$226,$228,$006,$006,$006
	dc.w	$006,$006,$006,$006,$006,$006,$006,$006

	dc.w	$006,$006,$006,$006,$006,$006,$006,$006
	dc.w	$006,$006,$006,$006,$006,$006,$006,$006
	dc.w	$006,$006,$006,$006,$006,$006,$006,$006
	dc.w	$006,$006,$006,$006,$006,$006,$006,$006
	dc.w	$006,$006,$006,$006,$006,$006,$006,$006
	dc.w	$006,$006,$006,$006,$006,$226,$226,$226
	dc.w	$226,$226,$226,$226,$226,$226,$226,$226
	dc.w	$226,$226,$226,$228,$228,$006,$006,$006
	dc.w	$006,$006,$006,$006,$006,$006,$006,$006

	dc.w	$226,$226,$226,$226,$226,$226,$226,$226
	dc.w	$226,$226,$226,$226,$226,$226,$226,$226
	dc.w	$226,$226,$226,$226,$226,$226,$226,$226
	dc.w	$226,$226,$226,$226,$226,$226,$226,$226
	dc.w	$226,$226,$226,$226,$226,$226,$226,$226
	dc.w	$226,$228,$228,$228,$228,$228,$228,$228
	dc.w	$228,$228,$228,$228,$228,$228,$228,$228
	dc.w	$228,$228,$228,$228,$228,$226,$226,$226
	dc.w	$226,$226,$226,$226,$226,$226,$226,$226

	dc.w	$228,$228,$228,$228,$228,$228,$228,$228
	dc.w	$228,$228,$228,$228,$228,$228,$228,$228
	dc.w	$228,$228,$228,$228,$228,$228,$228,$228
	dc.w	$228,$228,$228,$22a,$22a,$22a,$22a,$22a
	dc.w	$22a,$22a,$22a,$22a,$22a,$22a,$22a,$22a
	dc.w	$22a,$22a,$22a,$22a,$22a,$22a,$22a,$22a
	dc.w	$22a,$22a,$22a,$22a,$22a,$22a,$22a,$22a
	dc.w	$22a,$22a,$228,$228,$228,$228,$228,$228
	dc.w	$228,$228,$228,$228,$228,$228,$228,$228

	dc.w	$22a,$22a,$22a,$22a,$22a,$22a,$22a,$22a
	dc.w	$22a,$22a,$22a,$22a,$22a,$22a,$22a,$22a
	dc.w	$22a,$22a,$22a,$22a,$22a,$22a,$22a,$22a
	dc.w	$22a,$22a,$22c,$22c,$22c,$22c,$22c,$22c
	dc.w	$22c,$22c,$22c,$22c,$22c,$22c,$22c,$22c
	dc.w	$22c,$22c,$22c,$22c,$22c,$22c,$22c,$22c
	dc.w	$22c,$22c,$22c,$22c,$22c,$22a,$22a,$22a
	dc.w	$22a,$22a,$22a,$22a,$228,$22a,$22a,$22a
	dc.w	$22a,$22a,$22a,$22a,$22a,$22a,$22a,$22a

	dc.w	$22c,$22c,$22c,$22c,$22c,$22c,$22c,$22c
	dc.w	$22c,$22c,$22c,$22c,$22c,$22c,$22c,$22c
	dc.w	$22e,$22e,$22e,$22e,$22e,$22e,$22e,$22e
	dc.w	$22e,$22e,$22e,$22e,$22e,$22e,$22e,$22e
	dc.w	$22e,$22e,$22e,$22e,$22e,$22e,$22e,$22e
	dc.w	$22e,$22e,$22e,$22e,$22e,$22e,$22e,$22e
	dc.w	$22e,$22e,$22e,$22c,$22c,$22c,$22c,$22c
	dc.w	$22c,$22a,$22a,$22a,$228,$22c,$22c,$22c
	dc.w	$22c,$22c,$22c,$22c,$22c,$22c,$22c,$22c

;Colors for the rainbow
rainbowcolors:
	dc.w	$000,$020,$040,$060,$080,$0a0,$0c0,$0e0
	dc.w	$002,$022,$042,$062,$082,$0a2,$0c2,$0e2
	dc.w	$004,$024,$044,$064,$084,$0a4,$0c4,$0e4
	dc.w	$006,$026,$046,$066,$086,$0a6,$0c6,$0e6
	dc.w	$008,$028,$048,$068,$088,$0a8,$0c8,$0e8
	dc.w	$00a,$02a,$04a,$06a,$08a,$0aa,$0ca,$0ea
	dc.w	$00c,$02c,$04c,$06c,$08c,$0ac,$0cc,$0ec
	dc.w	$00e,$02e,$04e,$06e,$08e,$0ae,$0ce,$0ee
	dc.w	$600,$620,$640,$660,$680,$6a0,$6c0,$6e0
	dc.w	$602,$622,$642,$662,$682,$6a2,$6c2,$6e2
	dc.w	$604,$624,$644,$664,$684,$6a4,$6c4,$6e4
	dc.w	$606,$626,$646,$666,$686,$6a6,$6c6,$6e6
	dc.w	$608,$628,$648,$668,$688,$6a8,$6c8,$6e8
	dc.w	$60a,$62a,$64a,$66a,$68a,$6aa,$6ca,$6ea
	dc.w	$60c,$62c,$64c,$66c,$68c,$6ac,$6cc,$6ec
	dc.w	$60e,$62e,$64e,$66e,$68e,$6ae,$6ce,$6ee
	dc.w	$c00,$c20,$c40,$c60,$c80,$ca0,$cc0,$ce0
	dc.w	$c02,$c22,$c42,$c62,$c82,$ca2,$cc2,$ce2
	dc.w	$c04,$c24,$c44,$c64,$c84,$ca4,$cc4,$ce4
	dc.w	$c06,$c26,$c46,$c66,$c86,$ca6,$cc6,$ce6
	dc.w	$c08,$c28,$c48,$c68,$c88,$ca8,$cc8,$ce8
	dc.w	$c0a,$c2a,$c4a,$c6a,$c8a,$caa,$cca,$cea
	dc.w	$c0c,$c2c,$c4c,$c6c,$c8c,$cac,$ccc,$cec
	dc.w	$c0e,$c2e,$c4e,$c6e,$c8e,$cae,$cce,$cee
	dc.w	$200,$220,$240,$260,$280,$2a0,$2c0,$2e0
	dc.w	$202,$222,$242,$262,$282,$2a2,$2c2,$2e2
	dc.w	$204,$224,$244,$264,$284,$2a4,$2c4,$2e4
	dc.w	$206,$226,$246,$266,$286,$2a6,$2c6,$2e6
	dc.w	$208,$228,$248,$268,$288,$2a8,$2c8,$2e8
	dc.w	$20a,$22a,$24a,$26a,$28a,$2aa,$2ca,$2ea
	dc.w	$20c,$22c,$24c,$26c,$28c,$2ac,$2cc,$2ec
	dc.w	$20e,$22e,$24e,$26e,$28e,$2ae,$2ce,$2ee
	dc.w	$800,$820,$840,$860,$880,$8a0,$8c0,$8e0
	dc.w	$802,$822,$842,$862,$882,$8a2,$8c2,$8e2
	dc.w	$804,$824,$844,$864,$884,$8a4,$8c4,$8e4
	dc.w	$806,$826,$846,$866,$886,$8a6,$8c6,$8e6
	dc.w	$808,$828,$848,$868,$888,$8a8,$8c8,$8e8
	dc.w	$80a,$82a,$84a,$86a,$88a,$8aa,$8ca,$8ea
	dc.w	$80c,$82c,$84c,$86c,$88c,$8ac,$8cc,$8ec
	dc.w	$80e,$82e,$84e,$86e,$88e,$8ae,$8ce,$8ee
	dc.w	$e00,$e20,$e40,$e60,$e80,$ea0,$ec0,$ee0
	dc.w	$e02,$e22,$e42,$e62,$e82,$ea2,$ec2,$ee2
	dc.w	$e04,$e24,$e44,$e64,$e84,$ea4,$ec4,$ee4
	dc.w	$e06,$e26,$e46,$e66,$e86,$ea6,$ec6,$ee6
	dc.w	$e08,$e28,$e48,$e68,$e88,$ea8,$ec8,$ee8
	dc.w	$e0a,$e2a,$e4a,$e6a,$e8a,$eaa,$eca,$eea
	dc.w	$e0c,$e2c,$e4c,$e6c,$e8c,$eac,$ecc,$eec
	dc.w	$e0e,$e2e,$e4e,$e6e,$e8e,$eae,$ece,$eee
	dc.w	$400,$420,$440,$460,$480,$4a0,$4c0,$4e0
	dc.w	$402,$422,$442,$462,$482,$4a2,$4c2,$4e2
	dc.w	$404,$424,$444,$464,$484,$4a4,$4c4,$4e4
	dc.w	$406,$426,$446,$466,$486,$4a6,$4c6,$4e6
	dc.w	$408,$428,$448,$468,$488,$4a8,$4c8,$4e8
	dc.w	$40a,$42a,$44a,$46a,$48a,$4aa,$4ca,$4ea
	dc.w	$40c,$42c,$44c,$46c,$48c,$4ac,$4cc,$4ec
	dc.w	$40e,$42e,$44e,$46e,$48e,$4ae,$4ce,$4ee
	dc.w	$a00,$a20,$a40,$a60,$a80,$aa0,$ac0,$ae0
	dc.w	$a02,$a22,$a42,$a62,$a82,$aa2,$ac2,$ae2
	dc.w	$a04,$a24,$a44,$a64,$a84,$aa4,$ac4,$ae4
	dc.w	$a06,$a26,$a46,$a66,$a86,$aa6,$ac6,$ae6
	dc.w	$a08,$a28,$a48,$a68,$a88,$aa8,$ac8,$ae8
	dc.w	$a0a,$a2a,$a4a,$a6a,$a8a,$aaa,$aca,$aea
	dc.w	$a0c,$a2c,$a4c,$a6c,$a8c,$aac,$acc,$aec
	dc.w	$a0e,$a2e,$a4e,$a6e,$a8e,$aae,$ace,$aee
