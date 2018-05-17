.data

align 16

un_demi real4 0.5
un real4 1.0
val_180 tbyte 180.0
rad_deg tbyte 1.0
deg_rad tbyte 1.0
pi_sur_2 tbyte 1.0
moins_pi_sur_2 tbyte 1.0

.code

;Init_Maths387 proc
Init_Maths387 proc public frame

FPUState equ word ptr[rsp]

	sub rsp,8
	.allocstack 8
	.endprolog

	fstcw FPUState
	
	fldpi
	fld val_180
	fdivp
	fstp deg_rad
	
	fld val_180
	fldpi
	fdivp
	fstp rad_deg
	
	fldpi
	fmul dword ptr un_demi
	fstp pi_sur_2
	
	fldpi
	fmul dword ptr un_demi
	fchs
	fstp moins_pi_sur_2
	
	fldcw FPUState
	
	add rsp,8
	ret
	
Init_Maths387 endp	


;sin proc x:qword
sin proc public frame

x equ qword ptr[rsp+8]
	.endprolog
	
	movlpd x,xmm0
	
	fld x			;Charge x dans st(0)
	fsin			;Calcule sin st(0)
	
	fstp x	
	movlpd xmm0,x
	
	ret

sin endp


;cos proc x:qword
cos proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0
	
	fld x			;Charge x dans st(0)
	fcos			;Calcule cos st(0)
	
	fstp x	
	movlpd xmm0,x
	
	ret

cos endp


;exp proc x:qword
exp proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0
	
	fldl2e				; exp(x)=(2^n)*(2^a), ici on charge ln2(e) dans st(0)
	fld x				; charge x dans st(0) ( ln2(e) est dans st(1) )
	fmulp				; calcul de x*ln2(e)
	fld st(0)			; résultat dans st(1) et st(0)
	frndint				; partie entière n dans st(0)
	fsub st(1),st		; st(1):=st(1)-st(0) => a dans st(1);
	fxch st(1)			; a dans st(0) et n dans st(1)
	f2xm1				; calcul 2^a-1
	fadd dword ptr un	; dans st(0) on a 2^a et dans st(1) n
	fscale				; calcule st(0)*2^int(st(1)) ici (2^a)*(2^n)
	fxch st(1)			; échange st(1) et st(0)
	ffree st(0)			; libère st(0) pour vider la pile
	fincstp				; dépile et incrémente le compteur de pile
	
	fstp x
	movlpd xmm0,x
	
	ret
	
exp endp


;arctan proc x:qword
arctan proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0
	
	fld x			; charge x dans st(0)
	fld1			; Charge 1 dans st(0), x et dans st(1)
	fpatan			; calcule arctan(st(1)/st(0)), ce qui explique le résultat
	
	fstp x
	movlpd xmm0,x
	
	ret
	
arctan endp


;arctan2 proc x:qword,y:qword
arctan2 proc public frame

x equ qword ptr[rsp+8]
y equ qword ptr[rsp+16]
	
	.endprolog
	
	movlpd x,xmm0
	movlpd y,xmm1

	fld y			; charge y dans st(0)
	fld x			; charge x dans st(0), y est dans st(1)
	fpatan			; calcule calcul arctan(y/x)
	
	fstp x
	movlpd xmm0,x

	ret
	
arctan2 endp


;cotan proc x:qword
cotan proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0
	
	fld x				; charge x dans st(0)
	fptan				; calcule la tangente
	fdivrp				; divise et dépile st(1)=st(0)/st(1) et résultat dans
						; st(1) puis dépile donc résultat final dans st(0)
  
	fstp x
	movlpd xmm0,x

	ret
	
cotan endp


;sinh proc x:qword
sinh proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0

	fld x
	
	fldl2e				; Calcule exp(st(0))
	fmulp				; calcul de st(0)*ln2(e)
	fld st				; résultat dans st(1) et st(0)
	frndint				; partie entière n dans st(0)
	fsub st(1),st 		; st(1):=st(1)-st(0) => a dans st(1);
	fxch st(1)			; a dans st(0) et n dans st(1)
	f2xm1				; calcul 2^a-1
	fadd dword ptr un	; dans st(0) on a 2^a et dans st(1) n
	fscale				; calcule st(0)*2^int(st(1)) ici (2^a)*(2^n)
	fxch st(1)			; échange st(1) et st(0)
	ffree st(0)			; libère st(0) pour vider la pile
	fincstp				; dépile et incrémente le compteur de pile
	
	fld st(0)
	fdivr dword ptr un
	fsubp
	fmul dword ptr un_demi

	fstp x
	movlpd xmm0,x
	
	ret
	
sinh endp


;cosh proc x:qword
cosh proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0

	fld x
	
	fldl2e				; Calcule exp(st(0))
	fmulp				; calcul de st(0)*ln2(e)
	fld st				; résultat dans st(1) et st(0)
	frndint				; partie entière n dans st(0)
	fsub st(1),st 		; st(1):=st(1)-st(0) => a dans st(1);
	fxch st(1)			; a dans st(0) et n dans st(1)
	f2xm1				; calcul 2^a-1
	fadd dword ptr un	; dans st(0) on a 2^a et dans st(1) n
	fscale				; calcule st(0)*2^int(st(1)) ici (2^a)*(2^n)
	fxch st(1)			; échange st(1) et st(0)
	ffree st(0)			; libère st(0) pour vider la pile
	fincstp				; dépile et incrémente le compteur de pile
	
	fld st(0)
	fdivr dword ptr un
	faddp
	fmul dword ptr un_demi

	fstp x
	movlpd xmm0,x
	
	ret
	
cosh endp


;th proc x:qword
th proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0

	fld x
	
	fldl2e				; Calcule exp(st(0))
	fmulp				; calcul de st(0)*ln2(e)
	fld st				; résultat dans st(1) et st(0)
	frndint				; partie entière n dans st(0)
	fsub st(1),st 		; st(1):=st(1)-st(0) => a dans st(1);
	fxch st(1)			; a dans st(0) et n dans st(1)
	f2xm1				; calcul 2^a-1
	fadd dword ptr un	; dans st(0) on a 2^a et dans st(1) n
	fscale				; calcule st(0)*2^int(st(1)) ici (2^a)*(2^n)
	fxch st(1)			; échange st(1) et st(0)
	ffree st(0)			; libère st(0) pour vider la pile
	fincstp				; dépile et incrémente le compteur de pile
	
	fld st(0)
	fdivr dword ptr un		; exp(-x)=1/exp(x)
	fld st(1)				; st(0)=exp(x) st(1)=exp(-x) st(2)=exp(x)
	fsub st,st(1)			; st(0)= exp(x)-exp(-x)
	fxch st(2)
	faddp					; st(0)=exp(-x)+exp(x)
	fdivp					; th=exp(x)-exp(-x) / exp(x)+exp(-x)

	fstp x
	movlpd xmm0,x
	
	ret
	
th endp


;coth proc x:qword
coth proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0

	fld x
	
	fldl2e				; Calcule exp(st(0))
	fmulp				; calcul de st(0)*ln2(e)
	fld st				; résultat dans st(1) et st(0)
	frndint				; partie entière n dans st(0)
	fsub st(1),st 		; st(1):=st(1)-st(0) => a dans st(1);
	fxch st(1)			; a dans st(0) et n dans st(1)
	f2xm1				; calcul 2^a-1
	fadd dword ptr un	; dans st(0) on a 2^a et dans st(1) n
	fscale				; calcule st(0)*2^int(st(1)) ici (2^a)*(2^n)
	fxch st(1)			; échange st(1) et st(0)
	ffree st(0)			; libère st(0) pour vider la pile
	fincstp				; dépile et incrémente le compteur de pile
	
	fld st(0)
	fdivr dword ptr un
	fld st(1)
	fadd st,st(1)
	fxch st(2)
	fsubrp
	fdivp

	fstp x
	movlpd xmm0,x

	ret
	
coth endp


;argsh proc x:qword
argsh proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0

	fld x					; Charge x
	fld st
	fmul st,st
	fadd dword ptr un		; st(0)=x^2+1
	fsqrt
	faddp					; st(0)=x+sqrt(x^2+1)
	
	fldln2
	fxch st(1)
	fyl2x

	fstp x
	movlpd xmm0,x
	
	ret
	
argsh endp


;argch proc x:qword
argch proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0

	fld x
	fld st
	fmul st,st
	fsub dword ptr un
	fsqrt
	faddp					; st(0)=x+sqrt(x^2-1)
	
	fldln2
	fxch st(1)
	fyl2x

	fstp x
	movlpd xmm0,x
	
	ret
	
argch endp


;argth proc x:qword
argth proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0

	fld x
	fld st(0)
	fadd dword ptr un
	fxch st(1)
	fsubr dword ptr un
	fdivp					; st(0)=(1+x)/(1-x)
	
	fldln2
	fxch st(1)
	fyl2x
	
	fmul dword ptr un_demi

	fstp x
	movlpd xmm0,x
	
	ret
	
argth endp


;argcoth proc x:qword
argcoth proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0

	fld x
	fld st(0)
	fadd dword ptr un
	fxch st(1)
	fsub dword ptr un
	fdivp					; st(0)=(x+1)/(x-1)
	
	fldln2
	fxch st(1)
	fyl2x
	
	fmul dword ptr un_demi

	fstp x
	movlpd xmm0,x

	ret
	
argcoth endp


;logb proc a:qword,x:qword
logb proc public frame

a equ qword ptr[rsp+8]
x equ qword ptr[rsp+16]
	
	.endprolog
	
	movlpd a,xmm0
	movlpd x,xmm1

	fld1
	fld x
	fyl2x					; Calcule ln2(x)
	fld1
	fld a
	fyl2x					; Calcule ln2(a)
	fdivp					; ln base a de x = ln2(x)/ln2(a)

	fstp x
	movlpd xmm0,x

	ret
	
logb endp


;deg proc x:qword
deg proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0

	fld x
	fld rad_deg
	fmulp

	fstp x
	movlpd xmm0,x

	ret
	
deg endp



;rad proc x:qword
rad proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0

	fld x
	fld deg_rad
	fmulp

	fstp x
	movlpd xmm0,x

	ret
	
rad endp


;sgn proc x:qword
sgn proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0

	fld x
	ftst
	fstsw ax
	and ax,4100h
	jz short sgn_positif
	and ax,4000h
	jz short sgn_negatif
	mov ax,0
	
	ret
sgn_negatif:	
	mov ax,-1
	
	ret
sgn_positif:
	mov ax,1

	ret
	
sgn endp


internal_pow proc
	
	fyl2x					; st=x2*ln2(x1)
	fld st					; résultat dans st(1) et st(0)
	frndint					; partie entière n dans st(0)
	fsub st(1),st			; st(1):=st(1)-st(0) => a dans st(1);
	fxch st(1)				; a dans st(0) et n dans st(1)
	f2xm1					; calcul 2^a-1
	fadd un					; dans st(0) on a 2^a et dans st(1) n
	fscale					; calcule st(0)*2^int(st(1)) ici (2^a)*(2^n)
	fxch st(1)				; échange st(1) et st(0)
	ffree st(0)				; libère st(0) pour vider la pile
	fincstp					; dépile et incrémente le compteur de pile
	
	ret

internal_pow endp


;pow proc x:qword,y:qword
pow proc public frame

x equ qword ptr[rsp+8]
y equ qword ptr[rsp+16]
	
	.endprolog
	
	movlpd x,xmm0
	movlpd y,xmm1
	
	fld x
	ftst
	fstsw ax
	and ax,4100h
	jz short puiss_normale
	and ax,4000h
	jz short puiss_negative
	ffree st
	fincstp
	fld y
	ftst
	fstsw ax
	and ax,4000h
	jnz short puiss_exp_nul
	fldz
	
	fstp x
	movlpd xmm0,x
	
	ret
puiss_exp_nul:
	fld1

	fstp x
	movlpd xmm0,x
	
	ret
puiss_normale:
	fld y
	fxch st(1)
	call internal_pow
	
	fstp x
	movlpd xmm0,x
	
	ret
puiss_negative:
	fabs
	fld y
	frndint
	fld st
	fmul dword ptr un_demi
	fld st
	frndint
	fsubp
	ftst
	fstsw ax
	fxch st(1)
	and ax,4000h
	jnz short puiss_positif
	call internal_pow
	fchs
	
	fstp x
	movlpd xmm0,x
	
	ret
puiss_positif:
	call internal_pow	

	fstp x
	movlpd xmm0,x

	ret
	
pow endp


;root proc x:qword,y:qword
root proc public frame

x equ qword ptr[rsp+8]
y equ qword ptr[rsp+16]
	
	.endprolog
	
	movlpd x,xmm0
	movlpd y,xmm1
	
	fld x
	ftst
	fstsw ax
	and ax,4100h
	jz short racine_positive
	and ax,4000h
	jz short racine_negative
	ffree st
	fincstp
	fldz

	fstp x
	movlpd xmm0,x
	
	ret
racine_positive:
	fld y
	ftst
	fstsw ax
	and ax,4000h
	jz short racine_normale
sort_zero:
	ffree st
	fincstp
	ffree st
	fincstp
	fldz
	
	fstp x
	movlpd xmm0,x
	
	ret
racine_normale:
	fdivr dword ptr un
	fxch st(1)
	call internal_pow

	fstp x
	movlpd xmm0,x
	
	ret
racine_negative:
	fld y
	ftst
	fstsw ax
	and ax,4000h
	jnz short sort_zero
	frndint
	fld st
	fmul dword ptr un_demi
	fld st
	frndint
	fsubp
	ftst
	fstsw ax
	and ax,4000h
	jnz short sort_zero
	fdivr dword ptr un
	fxch st(1)
	fabs
	call internal_pow
	fchs

	fstp x
	movlpd xmm0,x
	
	ret
	
root endp


;arcsin proc x:qword
arcsin proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0

	fld x
	fld st
	fabs
	fcomp dword ptr un
	fstsw ax
	and ax,4000h
	jnz short egal_un
	fld st(0)
	fmul st,st
	fsubr dword ptr un
	fsqrt
	fpatan
	
	fstp x
	movlpd xmm0,x
	
	ret
egal_un:
	ftst
	fstsw ax
	and ax,0100h
	jnz short negatif
	fld pi_sur_2
	
	fstp x
	movlpd xmm0,x
	
	ret
negatif:
	fld moins_pi_sur_2

	fstp x
	movlpd xmm0,x
	
	ret
	
arcsin endp


;arccos proc x:qword
arccos proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0

	fld x
	ftst
	fstsw ax
	and ax,4000h
	jnz short egal_zero
	fld st(0)
	ftst
	fstsw ax
	fmul st,st
	fsubr dword ptr un
	fsqrt
	fxch st(1)
	fabs
	fpatan
	and ax,0100h
	jz short positif
	fldpi
	fsubrp
positif:

	fstp x
	movlpd xmm0,x

	ret
egal_zero:
	ffree st
	fincstp
	fld pi_sur_2

	fstp x
	movlpd xmm0,x
	
	ret
	
arccos endp


;arccotan proc x:qword
arccotan proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0

	fld1
	fld x
	ftst
	fstsw ax
	and ax,4000h
	jnz short arccotan_egal_zero
	fpatan

	fstp x
	movlpd xmm0,x
	
	ret
arccotan_egal_zero:
	ffree st
	fincstp
	ffree st
	fincstp
	fld pi_sur_2

	fstp x
	movlpd xmm0,x
	
	ret
	
arccotan endp


;sec proc x:qword
sec proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0

	public sec

	fld x
	fcos
	fmul st,st
	fdivr dword ptr un
	
	fstp x
	movlpd xmm0,x

	ret
	
sec endp


;cosec proc x:qword
cosec proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0

	public cosec

	fld x
	fsin
	fmul st,st
	fdivr dword ptr un
	
	fstp x
	movlpd xmm0,x

	ret
	
cosec endp


;sinc proc x:qword
sinc proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0
	
	fld x
	ftst
	fstsw ax
	and ax,4000h
	jnz short sinc_egal_zero
	fld st
	fsin
	fdivrp
	
	fstp x
	movlpd xmm0,x
	
	ret
sinc_egal_zero:
	ffree st
	fincstp
	fld1
	
	fstp x
	movlpd xmm0,x

	ret
	
sinc endp


;lnp1 proc x:qword
lnp1 proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0
	
	fldln2
	fld x
	fcom dword ptr un
	fstsw ax
	and ax,0100h
	jnz short plus_petit
	fadd dword ptr  un
	fyl2x
	
	fstp x
	movlpd xmm0,x
	
	ret
plus_petit:
	fyl2xp1

	fstp x
	movlpd xmm0,x
	
	ret
	
lnp1 endp


;expm proc x:qword
expm proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0
	
	fldl2e
	fld x
	fmulp
	fld st
	fabs
	fcomp dword ptr un
	fstsw ax
	and ax,0100h
	jz short plus_grand_que_un
	f2xm1

	fstp x
	movlpd xmm0,x
	
	ret
plus_grand_que_un:
	fld st					; résultat dans st(1) et st(0)
	frndint					; partie entière n dans st(0)
	fsub st(1),st			; t(1):=st(1)-st(0) => a dans st(1);
	fxch st(1)				; a dans st(0) et n dans st(1)
	f2xm1					; calcul 2^a-1
	fadd dword ptr un		; dans st(0) on a 2^a et dans st(1) n
	fscale					; calcule st(0)*2^int(st(1)) ici (2^a)*(2^n)
	fxch st(1)				; échange st(1) et st(0)
	ffree st(0)				; libère st(0) pour vider la pile
	fincstp					; dépile et incrémente le compteur de pile
	fsub dword ptr un		; st(0)=exp(x)-1

	fstp x
	movlpd xmm0,x
	
	ret
	
expm endp


;ln proc x:qword
ln proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0

	fldln2					; Charge ln(2)
	fld x					; Charge x
	fyl2x					; Calcule st(1)*ln2(st(0)) -> ln(2)*ln2(x)
	
	fstp x
	movlpd xmm0,x

	ret
	
ln endp


;pow2 proc x:qword
pow2 proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0

	fld x					; Charge x dans st(0)
	fld st					; Recopie dans st(1)
	frndint					; st(0) = int(st(0))
	fsub st(1),st			; st(1):=st(1)-st(0) => a dans st(1);
	fxch st(1)				; a dans st(0) et n dans st(1)
	f2xm1					; calcul 2^a-1
	fadd dword ptr un		; dans st(0) on a 2^a et dans st(1) n
	fscale					; calcule st(0)*2^int(st(1)) ici (2^a)*(2^n)
	fxch st(1)				; échange st(1) et st(0)
	ffree st(0)				; libère st(0) pour vider la pile
	fincstp					; dépile et incrémente le compteur de pile
	
	fstp x
	movlpd xmm0,x

	ret
	
pow2 endp


;ln2 proc x:qword
ln2 proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0

	fld1					; Charge 1
	fld x
	fyl2x					; Calcul ln2(x)
	
	fstp x
	movlpd xmm0,x

	ret
	
ln2 endp


;angle proc x:qword,y:qword
angle proc public frame

x equ qword ptr[rsp+8]
y equ qword ptr[rsp+16]
	
	.endprolog
	
	movlpd x,xmm0
	movlpd y,xmm1

	fld y
	fld x
	fpatan
	fld rad_deg
	fmulp
	
	fstp x
	movlpd xmm0,x

	ret
	
angle endp


; Neural network functions, sigmoïd logsid and derivated

;logsig proc x:qword
logsig proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0
	
	fld x
	fchs
	
	fldl2e				; Calcule exp(st(0))
	fmulp				; calcul de st(0)*ln2(e)
	fld st				; résultat dans st(1) et st(0)
	frndint				; partie entière n dans st(0)
	fsub st(1),st 		; st(1):=st(1)-st(0) => a dans st(1);
	fxch st(1)			; a dans st(0) et n dans st(1)
	f2xm1				; calcul 2^a-1
	fadd dword ptr un	; dans st(0) on a 2^a et dans st(1) n
	fscale				; calcule st(0)*2^int(st(1)) ici (2^a)*(2^n)
	fxch st(1)			; échange st(1) et st(0)
	ffree st(0)			; libère st(0) pour vider la pile
	fincstp				; dépile et incrémente le compteur de pile
	
	fadd dword ptr un		; st(0)=1+exp(-x)
	fdivr dword ptr un		; st(0)=1/st(0)
	
	fstp x
	movlpd xmm0,x

	ret
	
logsig endp


;d_logsig proc x:qword
d_logsig proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0
	
	fld x
	fchs
	
	fldl2e				; Calcule exp(st(0))
	fmulp				; calcul de st(0)*ln2(e)
	fld st				; résultat dans st(1) et st(0)
	frndint				; partie entière n dans st(0)
	fsub st(1),st 		; st(1):=st(1)-st(0) => a dans st(1);
	fxch st(1)			; a dans st(0) et n dans st(1)
	f2xm1				; calcul 2^a-1
	fadd dword ptr un	; dans st(0) on a 2^a et dans st(1) n
	fscale				; calcule st(0)*2^int(st(1)) ici (2^a)*(2^n)
	fxch st(1)			; échange st(1) et st(0)
	ffree st(0)			; libère st(0) pour vider la pile
	fincstp				; dépile et incrémente le compteur de pile
	
	fadd dword ptr un		; st(0)=1+exp(-x)
	fdivr dword ptr un		; st(0)=1/st(0)
	fld st(0)				; st(1)=st(0)
	fsubr dword ptr un		; st(0)=1-st(0)
	fmulp					; st(0)=st(1)*(1-st(0))
	
	fstp x
	movlpd xmm0,x

	ret
	
d_logsig endp


;tansig proc x:qword
tansig proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0

	fld x
	
	fldl2e				; Calcule exp(st(0))
	fmulp				; calcul de st(0)*ln2(e)
	fld st				; résultat dans st(1) et st(0)
	frndint				; partie entière n dans st(0)
	fsub st(1),st 		; st(1):=st(1)-st(0) => a dans st(1);
	fxch st(1)			; a dans st(0) et n dans st(1)
	f2xm1				; calcul 2^a-1
	fadd dword ptr un	; dans st(0) on a 2^a et dans st(1) n
	fscale				; calcule st(0)*2^int(st(1)) ici (2^a)*(2^n)
	fxch st(1)			; échange st(1) et st(0)
	ffree st(0)			; libère st(0) pour vider la pile
	fincstp				; dépile et incrémente le compteur de pile
	
	fld st(0)
	fdivr dword ptr un		; exp(-x)=1/exp(x)
	fld st(1)				; st(0)=exp(x) st(1)=exp(-x) st(2)=exp(x)
	fsub st,st(1)			; st(0)= exp(x)-exp(-x)
	fxch st(2)
	faddp					; st(0)=exp(-x)+exp(x)
	fdivp					; st(0)=exp(x)-exp(-x) / exp(x)+exp(-x)

	fstp x
	movlpd xmm0,x
	
	ret
	
tansig endp


;d_tansig proc x:qword
d_tansig proc public frame

x equ qword ptr[rsp+8]
	
	.endprolog
	
	movlpd x,xmm0

	fld x
	
	fldl2e				; Calcule exp(st(0))
	fmulp				; calcul de st(0)*ln2(e)
	fld st				; résultat dans st(1) et st(0)
	frndint				; partie entière n dans st(0)
	fsub st(1),st 		; st(1):=st(1)-st(0) => a dans st(1);
	fxch st(1)			; a dans st(0) et n dans st(1)
	f2xm1				; calcul 2^a-1
	fadd dword ptr un	; dans st(0) on a 2^a et dans st(1) n
	fscale				; calcule st(0)*2^int(st(1)) ici (2^a)*(2^n)
	fxch st(1)			; échange st(1) et st(0)
	ffree st(0)			; libère st(0) pour vider la pile
	fincstp				; dépile et incrémente le compteur de pile
	
	fld st(0)
	fdivr dword ptr un		; exp(-x)=1/exp(x)
	fld st(1)				; st(0)=exp(x) st(1)=exp(-x) st(2)=exp(x)
	fsub st,st(1)			; st(0)= exp(x)-exp(-x)
	fxch st(2)
	faddp					; st(0)=exp(-x)+exp(x)
	fdivp					; st(0)=exp(x)-exp(-x) / exp(x)+exp(-x)
	fmul st(0),st(0)		; st(0)=st(0)^2
	fsubr dword ptr un		; st(0)=1-st(0)

	fstp x
	movlpd xmm0,x
	
	ret
	
d_tansig endp

end





