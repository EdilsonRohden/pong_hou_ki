.data
	win_0_message:	.asciiz "\n\nO time \"O\" venceu!!!"
	win_1_message:	.asciiz "\n\nO time \"I\" venceu!!!"	
	mov_0_message:	.asciiz "\nMovimento para \"O\": "
	mov_1_message:	.asciiz "\nMovimento para \"I\": "
	invalid_move_message:	.asciiz "\nMovimento inválido\n"
	header_footer:		.asciiz "===================\n"
	new_line:	.asciiz "|\n"
	white_space:	.asciiz	"|-|---"
	empty_space:	.asciiz	"|   "	
	O_space:	.asciiz	"| O "
	I_space:	.asciiz	"| I "
	one_space:	.asciiz "|1"
	two_space:	.asciiz "|2"
	three_space:	.asciiz "|3"
	four_space:	.asciiz "|4"
	five_space:	.asciiz "|5"

.text
	setup:
		li	$s7, 0
		li	$s4, 0
		li	$s6, 1
		li	$s3, 1
		li	$s5, 2
		jal	print_table
		j	while_loop

	while_loop:
		jal	asks_0_move
		jal	move_table
		jal	print_table
		jal	check_for_victory
		jal	asks_1_move
		jal	move_table
		jal	print_table
		jal	check_for_victory
		j	while_loop

	#Imprime a tabela com base nos registradores.
	print_table:
		move	$s1, $ra
		jal	print_header_footer
		jal	print_s7
		jal	print_white
		jal	print_s4
		jal	print_ln
		jal	print_white
		jal	print_s5
		jal	print_white
		jal	print_ln
		jal	print_s6
		jal	print_white
		jal	print_s3
		jal	print_ln
		jal	print_header_footer		
		jr	$s1

	#Altera a tabela com base no movimento do jogador.
	move_table:
		beq	$s0, 1, move_s7
		beq	$s0, 2, move_s6
		beq	$s0, 3, move_s5
		beq	$s0, 4, move_s4
		beq	$s0, 5, move_s3
		j	invalid_move
		#Verificando possibilidades de movimento para s7
		move_s7:
			beq	$s5, 2, s7_to_s5
			beq	$s6, 2, s7_to_s6
			j	invalid_move
			s7_to_s5:
				move	$s5, $s7
				li	$s7, 2
				jr	$ra
			s7_to_s6:
				move	$s6, $s7
				li	$s7, 2
				jr	$ra
		#Verificando possibilidades de movimento para s6
		move_s6:
			beq	$s5, 2, s6_to_s5
			beq	$s7, 2, s6_to_s7
			beq	$s3, 2, s6_to_s3
			j	invalid_move
			s6_to_s7:
				move	$s7, $s6
				li	$s6, 2
				jr	$ra
			s6_to_s5:
				move	$s5, $s6
				li	$s6, 2
				jr	$ra
			s6_to_s3:
				move	$s3, $s6
				li	$s6, 2
				jr	$ra
		#Verificando possibilidades de movimento para s5
		move_s5:
			beq	$s7, 2, s5_to_s7
			beq	$s6, 2, s5_to_s6
			beq	$s4, 2, s5_to_s4
			beq	$s3, 2, s5_to_s3
			j	invalid_move
			s5_to_s7:
				move	$s7, $s5
				li	$s5, 2
				jr	$ra			
			s5_to_s6:
				move	$s6, $s5
				li	$s5, 2
				jr	$ra
			s5_to_s4:
				move	$s4, $s5
				li	$s5, 2
				jr	$ra
			s5_to_s3:
				move	$s3, $s5
				li	$s5, 2
				jr	$ra
		#Verificando possibilidades de movimento para s4
		move_s4:
			beq	$s5, 2, s4_to_s5
			beq	$s3, 2, s4_to_s3
			j	invalid_move
			s4_to_s5:
				move	$s5, $s4
				li	$s4, 2
				jr	$ra			
			s4_to_s3:
				move	$s3, $s4
				li	$s4, 2
				jr	$ra
		move_s3:
			beq	$s4, 2, s3_to_s4
			beq	$s5, 2, s3_to_s5
			beq	$s6, 2, s3_to_s6
			j	invalid_move
			s3_to_s4:
				move	$s4, $s3
				li	$s3, 2
				jr	$ra				
			s3_to_s5:
				move	$s5, $s3
				li	$s3, 2
				jr	$ra
			s3_to_s6:
				move	$s6, $s3
				li	$s3, 2
				jr	$ra								

	#Verifica se o jogador ganhou.
	check_for_victory:
		beq	$s6, $s5, s6_eq_s5
		beq	$s3, $s5, s3_eq_s5
		jr	$ra
		s6_eq_s5:
			beq	$s7, 2, winner
			jr	$ra
		s3_eq_s5:
			beq	$s4, 2, winner
			jr	$ra
		winner:
			beqz	$s5, win_0
			j	win_1			

	asks_0_move:
		#Printa a mensagem para pedir movimento.
		la	$a0, mov_0_message
		li	$v0, 4
		syscall
		#Realiza a leitura do movimento.
		li	$v0, 5
		syscall
		move	$s0, $v0
		#Validação de pedido de movimento
		beq	$s0, 1, O_asks_for_s7
		beq	$s0, 2, O_asks_for_s6
		beq	$s0, 3, O_asks_for_s5
		beq	$s0, 4, O_asks_for_s4
		beq	$s0, 5, O_asks_for_s3
		O_asks_for_s7:
			bnez	$s7, invalid_move
			jr	$ra
		O_asks_for_s6:
			bnez	$s6, invalid_move
			jr	$ra
		O_asks_for_s5:
			bnez	$s5, invalid_move			
			jr	$ra
		O_asks_for_s4:
			bnez	$s4, invalid_move
			jr	$ra
		O_asks_for_s3:
			bnez	$s3, invalid_move			
			jr	$ra
	asks_1_move:
		#Printa a mensagem para pedir movimento.
		la	$a0, mov_1_message
		li	$v0, 4
		syscall
		#Realiza a leitura do movimento.
		li	$v0, 5
		syscall
		#Validação de pedido de movimento
		move	$s0, $v0
		beq	$s0, 1, I_asks_for_s7
		beq	$s0, 2, I_asks_for_s6
		beq	$s0, 3, I_asks_for_s5
		beq	$s0, 4, I_asks_for_s4
		beq	$s0, 5, I_asks_for_s3
		I_asks_for_s7:
			bne	$s7, 1, invalid_move
			jr	$ra
		I_asks_for_s6:
			bne	$s6, 1, invalid_move
			jr	$ra
		I_asks_for_s5:
			bne	$s5, 1, invalid_move			
			jr	$ra
		I_asks_for_s4:
			bne	$s4, 1, invalid_move
			jr	$ra
		I_asks_for_s3:
			bne	$s3, 1, invalid_move			
			jr	$ra
	win_0:
		#Printa a mensagem de vitória e finaliza.
		la	$a0, win_0_message
		li	$v0, 4
		syscall
		j	exit
	win_1:
		#Printa a mensagem de vitória e finaliza.
		la	$a0, win_1_message
		li	$v0, 4
		syscall
		j	exit	
	
	invalid_move:
		#Printa a mensagem de movimento invalido e finaliza
		la	$a0, invalid_move_message
		li	$v0, 4
		syscall
		j	exit				
		
	exit:
		#Carrega o código e finaliza.
		li	$v0, 10
		syscall

	#Imprime uma nova linha.
	print_ln:
		la	$a0, new_line
		j	print_return
		
	#Imprime header_footer.
	print_header_footer:
		la	$a0, header_footer
		j	print_return

	#Imprime um espaço vaziu.
	print_white:
		la	$a0, white_space
		j	print_return

	#Verifica o valor e imprime o espaço para s7
	print_s7:
		#Imprime o indicador da posição.
		la	$a0, one_space
		li	$v0, 4
		syscall
		
		beq	$s7, 1, s7_I
		beqz	$s7, s7_O
		la	$a0, empty_space
		j	print_return
		s7_I:
			la	$a0, I_space
			j	print_return
		s7_O:
			la	$a0, O_space
			j	print_return

	#Verifica o valor e imprime o espaço para s6
	print_s6:
		#Imprime o indicador da posição.
		la	$a0, two_space
		li	$v0, 4
		syscall	
		beq	$s6, 1, s6_I
		beqz	$s6, s6_O
		la	$a0, empty_space
		j	print_return
		s6_I:
			la	$a0, I_space
			j	print_return
		s6_O:
			la	$a0, O_space
			j	print_return

	#Verifica o valor e imprime o espaço para s5
	print_s5:
		#Imprime o indicador da posição.
		la	$a0, three_space
		li	$v0, 4
		syscall
		beq	$s5, 1, s5_I
		beqz	$s5, s5_O
		la	$a0, empty_space
		j	print_return
		s5_I:
			la	$a0, I_space
			j	print_return
		s5_O:
			la	$a0, O_space
			j	print_return

	#Verifica o valor e imprime o espaço para s4
	print_s4:
		#Imprime o indicador da posição.
		la	$a0, four_space
		li	$v0, 4
		syscall
		beq	$s4, 1, s4_I
		beqz	$s4, s4_O
		la	$a0, empty_space
		j	print_return
		s4_I:
			la	$a0, I_space
			j	print_return
		s4_O:
			la	$a0, O_space
			j	print_return

	#Verifica o valor e imprime o espaço para s3
	print_s3:
		#Imprime o indicador da posição.
		la	$a0, five_space
		li	$v0, 4
		syscall	
		beq	$s3, 1, s3_I
		beqz	$s3, s3_O
		la	$a0, empty_space
		j	print_return
		s3_I:
			la	$a0, I_space
			j	print_return
		s3_O:
			la	$a0, O_space
			j	print_return

	#Imprime o que está carregado no registrador $a0 e retorna para o registrador $ra
	print_return:
		li	$v0, 4
		syscall
		jr	$ra		