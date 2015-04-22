.file	"x86cpuid.s"
.text
.globl	_fips_openssl_ia32_cpuid
.align	4
_fips_openssl_ia32_cpuid:
L_OPENSSL_ia32_cpuid_begin:
	pushl	%ebp
	pushl	%ebx
	pushl	%esi
	pushl	%edi
	xorl	%edx,%edx
	pushfl
	popl	%eax
	movl	%eax,%ecx
	xorl	$2097152,%eax
	pushl	%eax
	popfl
	pushfl
	popl	%eax
	xorl	%eax,%ecx
	btl	$21,%ecx
	jnc	L000generic
	xorl	%eax,%eax
	.byte	0x0f,0xa2
	movl	%eax,%edi
	xorl	%eax,%eax
	cmpl	$1970169159,%ebx
	setne	%al
	movl	%eax,%ebp
	cmpl	$1231384169,%edx
	setne	%al
	orl	%eax,%ebp
	cmpl	$1818588270,%ecx
	setne	%al
	orl	%eax,%ebp
	jz	L001intel
	cmpl	$1752462657,%ebx
	setne	%al
	movl	%eax,%esi
	cmpl	$1769238117,%edx
	setne	%al
	orl	%eax,%esi
	cmpl	$1145913699,%ecx
	setne	%al
	orl	%eax,%esi
	jnz	L001intel
	movl	$2147483648,%eax
	.byte	0x0f,0xa2
	cmpl	$2147483649,%eax
	jb	L001intel
	movl	%eax,%esi
	movl	$2147483649,%eax
	.byte	0x0f,0xa2
	orl	%ecx,%ebp
	andl	$2049,%ebp
	cmpl	$2147483656,%esi
	jb	L001intel
	movl	$2147483656,%eax
	.byte	0x0f,0xa2
	movzbl	%cl,%esi
	incl	%esi
	movl	$1,%eax
	.byte	0x0f,0xa2
	btl	$28,%edx
	jnc	L000generic
	shrl	$16,%ebx
	andl	$255,%ebx
	cmpl	%esi,%ebx
	ja	L000generic
	andl	$4026531839,%edx
	jmp	L000generic
L001intel:
	cmpl	$4,%edi
	movl	$-1,%edi
	jb	L002nocacheinfo
	movl	$4,%eax
	movl	$0,%ecx
	.byte	0x0f,0xa2
	movl	%eax,%edi
	shrl	$14,%edi
	andl	$4095,%edi
L002nocacheinfo:
	movl	$1,%eax
	.byte	0x0f,0xa2
	andl	$3220176895,%edx
	cmpl	$0,%ebp
	jne	L003notintel
	orl	$1073741824,%edx
	andb	$15,%ah
	cmpb	$15,%ah
	jne	L003notintel
	orl	$1048576,%edx
L003notintel:
	btl	$28,%edx
	jnc	L000generic
	andl	$4026531839,%edx
	cmpl	$0,%edi
	je	L000generic
	orl	$268435456,%edx
	shrl	$16,%ebx
	cmpb	$1,%bl
	ja	L000generic
	andl	$4026531839,%edx
L000generic:
	andl	$2048,%ebp
	andl	$4294965247,%ecx
	movl	%edx,%esi
	orl	%ecx,%ebp
	btl	$27,%ecx
	jnc	L004clear_avx
	xorl	%ecx,%ecx
.byte	15,1,208
	andl	$6,%eax
	cmpl	$6,%eax
	je	L005done
	cmpl	$2,%eax
	je	L004clear_avx
L006clear_xmm:
	andl	$4261412861,%ebp
	andl	$4278190079,%esi
L004clear_avx:
	andl	$4026525695,%ebp
L005done:
	movl	%esi,%eax
	movl	%ebp,%edx
	popl	%edi
	popl	%esi
	popl	%ebx
	popl	%ebp
	ret
.globl	_fips_openssl_rdtsc
.align	4
_fips_openssl_rdtsc:
L_OPENSSL_rdtsc_begin:
	xorl	%eax,%eax
	xorl	%edx,%edx
	call	L007PIC_me_up
L007PIC_me_up:
	popl	%ecx
	movl	L_OPENSSL_ia32cap_P$non_lazy_ptr-L007PIC_me_up(%ecx),%ecx
	btl	$4,(%ecx)
	jnc	L008notsc
	.byte	0x0f,0x31
L008notsc:
	ret
.globl	_fips_openssl_instrument_halt
.align	4
_fips_openssl_instrument_halt:
L_OPENSSL_instrument_halt_begin:
	call	L009PIC_me_up
L009PIC_me_up:
	popl	%ecx
	movl	L_OPENSSL_ia32cap_P$non_lazy_ptr-L009PIC_me_up(%ecx),%ecx
	btl	$4,(%ecx)
	jnc	L010nohalt
.long	2421723150
	andl	$3,%eax
	jnz	L010nohalt
	pushfl
	popl	%eax
	btl	$9,%eax
	jnc	L010nohalt
	.byte	0x0f,0x31
	pushl	%edx
	pushl	%eax
	hlt
	.byte	0x0f,0x31
	subl	(%esp),%eax
	sbbl	4(%esp),%edx
	addl	$8,%esp
	ret
L010nohalt:
	xorl	%eax,%eax
	xorl	%edx,%edx
	ret
.globl	_fips_openssl_far_spin
.align	4
_fips_openssl_far_spin:
L_OPENSSL_far_spin_begin:
	pushfl
	popl	%eax
	btl	$9,%eax
	jnc	L011nospin
	movl	4(%esp),%eax
	movl	8(%esp),%ecx
.long	2430111262
	xorl	%eax,%eax
	movl	(%ecx),%edx
	jmp	L012spin
.align	4,0x90
L012spin:
	incl	%eax
	cmpl	(%ecx),%edx
	je	L012spin
.long	529567888
	ret
L011nospin:
	xorl	%eax,%eax
	xorl	%edx,%edx
	ret
.globl	_fips_openssl_wipe_cpu
.align	4
_fips_openssl_wipe_cpu:
L_OPENSSL_wipe_cpu_begin:
	xorl	%eax,%eax
	xorl	%edx,%edx
	call	L013PIC_me_up
L013PIC_me_up:
	popl	%ecx
	movl	L_OPENSSL_ia32cap_P$non_lazy_ptr-L013PIC_me_up(%ecx),%ecx
	movl	(%ecx),%ecx
	btl	$1,(%ecx)
	jnc	L014no_x87
	andl	$83886080,%ecx
	cmpl	$83886080,%ecx
	jne	L015no_sse2
	pxor	%xmm0,%xmm0
	pxor	%xmm1,%xmm1
	pxor	%xmm2,%xmm2
	pxor	%xmm3,%xmm3
	pxor	%xmm4,%xmm4
	pxor	%xmm5,%xmm5
	pxor	%xmm6,%xmm6
	pxor	%xmm7,%xmm7
L015no_sse2:
.long	4007259865,4007259865,4007259865,4007259865,2430851995
L014no_x87:
	leal	4(%esp),%eax
	ret
.globl	_fips_openssl_atomic_add
.align	4
_fips_openssl_atomic_add:
L_OPENSSL_atomic_add_begin:
	movl	4(%esp),%edx
	movl	8(%esp),%ecx
	pushl	%ebx
	nop
	movl	(%edx),%eax
L016spin:
	leal	(%eax,%ecx,1),%ebx
	nop
.long	447811568
	jne	L016spin
	movl	%ebx,%eax
	popl	%ebx
	ret
.globl	_fips_openssl_indirect_call
.align	4
_fips_openssl_indirect_call:
L_OPENSSL_indirect_call_begin:
	pushl	%ebp
	movl	%esp,%ebp
	subl	$28,%esp
	movl	12(%ebp),%ecx
	movl	%ecx,(%esp)
	movl	16(%ebp),%edx
	movl	%edx,4(%esp)
	movl	20(%ebp),%eax
	movl	%eax,8(%esp)
	movl	24(%ebp),%eax
	movl	%eax,12(%esp)
	movl	28(%ebp),%eax
	movl	%eax,16(%esp)
	movl	32(%ebp),%eax
	movl	%eax,20(%esp)
	movl	36(%ebp),%eax
	movl	%eax,24(%esp)
	call	*8(%ebp)
	movl	%ebp,%esp
	popl	%ebp
	ret
.globl	_FIPS_openssl_cleanse
.align	4
_FIPS_openssl_cleanse:
L_OPENSSL_cleanse_begin:
	movl	4(%esp),%edx
	movl	8(%esp),%ecx
	xorl	%eax,%eax
	cmpl	$7,%ecx
	jae	L017lot
	cmpl	$0,%ecx
	je	L018ret
L019little:
	movb	%al,(%edx)
	subl	$1,%ecx
	leal	1(%edx),%edx
	jnz	L019little
L018ret:
	ret
.align	4,0x90
L017lot:
	testl	$3,%edx
	jz	L020aligned
	movb	%al,(%edx)
	leal	-1(%ecx),%ecx
	leal	1(%edx),%edx
	jmp	L017lot
L020aligned:
	movl	%eax,(%edx)
	leal	-4(%ecx),%ecx
	testl	$-4,%ecx
	leal	4(%edx),%edx
	jnz	L020aligned
	cmpl	$0,%ecx
	jne	L019little
	ret
.globl	_fips_openssl_instrument_bus
.align	4
_fips_openssl_instrument_bus:
L_OPENSSL_instrument_bus_begin:
	pushl	%ebp
	pushl	%ebx
	pushl	%esi
	pushl	%edi
	movl	$0,%eax
	call	L021PIC_me_up
L021PIC_me_up:
	popl	%edx
	movl	L_OPENSSL_ia32cap_P$non_lazy_ptr-L021PIC_me_up(%edx),%edx
	btl	$4,(%edx)
	jnc	L022nogo
	btl	$19,(%edx)
	jnc	L022nogo
	movl	20(%esp),%edi
	movl	24(%esp),%ecx
	.byte	0x0f,0x31
	movl	%eax,%esi
	movl	$0,%ebx
	clflush	(%edi)
.byte	240
	addl	%ebx,(%edi)
	jmp	L023loop
.align	4,0x90
L023loop:
	.byte	0x0f,0x31
	movl	%eax,%edx
	subl	%esi,%eax
	movl	%edx,%esi
	movl	%eax,%ebx
	clflush	(%edi)
.byte	240
	addl	%eax,(%edi)
	leal	4(%edi),%edi
	subl	$1,%ecx
	jnz	L023loop
	movl	24(%esp),%eax
L022nogo:
	popl	%edi
	popl	%esi
	popl	%ebx
	popl	%ebp
	ret
.globl	_fips_openssl_instrument_bus2
.align	4
_fips_openssl_instrument_bus2:
L_OPENSSL_instrument_bus2_begin:
	pushl	%ebp
	pushl	%ebx
	pushl	%esi
	pushl	%edi
	movl	$0,%eax
	call	L024PIC_me_up
L024PIC_me_up:
	popl	%edx
	movl	L_OPENSSL_ia32cap_P$non_lazy_ptr-L024PIC_me_up(%edx),%edx
	btl	$4,(%edx)
	jnc	L025nogo
	btl	$19,(%edx)
	jnc	L025nogo
	movl	20(%esp),%edi
	movl	24(%esp),%ecx
	movl	28(%esp),%ebp
	.byte	0x0f,0x31
	movl	%eax,%esi
	movl	$0,%ebx
	clflush	(%edi)
.byte	240
	addl	%ebx,(%edi)
	.byte	0x0f,0x31
	movl	%eax,%edx
	subl	%esi,%eax
	movl	%edx,%esi
	movl	%eax,%ebx
	jmp	L026loop2
.align	4,0x90
L026loop2:
	clflush	(%edi)
.byte	240
	addl	%eax,(%edi)
	subl	$1,%ebp
	jz	L027done2
	.byte	0x0f,0x31
	movl	%eax,%edx
	subl	%esi,%eax
	movl	%edx,%esi
	cmpl	%ebx,%eax
	movl	%eax,%ebx
	movl	$0,%edx
	setne	%dl
	subl	%edx,%ecx
	leal	(%edi,%edx,4),%edi
	jnz	L026loop2
L027done2:
	movl	24(%esp),%eax
	subl	%ecx,%eax
L025nogo:
	popl	%edi
	popl	%esi
	popl	%ebx
	popl	%ebp
	ret
.globl	_fips_openssl_ia32_rdrand
.align	4
_fips_openssl_ia32_rdrand:
L_OPENSSL_ia32_rdrand_begin:
	movl	$8,%ecx
L028loop:
.byte	15,199,240
	jc	L029break
	loop	L028loop
L029break:
	cmpl	$0,%eax
	cmovel	%ecx,%eax
	ret
.section __IMPORT,__pointers,non_lazy_symbol_pointers
L_OPENSSL_ia32cap_P$non_lazy_ptr:
.indirect_symbol	_fips_openssl_ia32cap_p
.long	0
.comm	_fips_openssl_ia32cap_p,8
.mod_init_func
.align 2
.long   _fips_openssl_cpuid_setup
