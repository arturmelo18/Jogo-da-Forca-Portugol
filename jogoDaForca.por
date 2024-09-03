programa
{
	inclua biblioteca Arquivos --> arq
	inclua biblioteca Util --> util
	inclua biblioteca Texto --> txt
	inclua biblioteca Tipos --> t
	inclua biblioteca Sons --> sons
	funcao inicio()
	{	
		//Função responsável pelo início do programa.
		//Também é responsável por iniciar as váriaveis que serão utilizadas ao longo do jogo
		
		inteiro erros = 0, tentativas = 0, contDicas = 2, tempo
		cadeia caracteresPalavra[50], palavrasDicas[100][11], palavra, letrasFaladas[26]

		tempo = menu()
		
		lerArquivo(palavrasDicas)

		inteiro somJogo = sons.carregar_som("./somJogo.mp3")
		sons.reproduzir_som(somJogo, verdadeiro)
		sons.definir_volume_reproducao(somJogo, 70)

		palavra = palavraSorteada(palavrasDicas)

		jogo(erros, tentativas, caracteresPalavra, palavrasDicas, palavra, letrasFaladas, contDicas, tempo, somJogo)
	}

	funcao jogo(inteiro erros, inteiro tentativas, cadeia caracteresPalavra[], cadeia palavrasDicas[][], cadeia palavra, cadeia letrasFaladas[], inteiro contDicas, inteiro tempo, inteiro somJogo){
		//Função principal do jogo. Aqui é onde todas as funções se interligam
		
		cadeia c
		logico vida = verdadeiro
		
		vida = desenha(erros, vida)

		inteiro numSort = encontraPalavra(palavra, palavrasDicas)
		
		tracos(palavra, tentativas, caracteresPalavra, letrasFaladas)
		se(tentativas == 0){
			escrevaDicas(palavrasDicas, numSort, 1)
		}

		se(vida == falso){
			perdeu(tentativas, palavra, somJogo)
			
		} senao {

			util.tempo_decorrido()
			inteiro t = util.tempo_decorrido()

			cadeia resp
			escreva("Fale uma letra: \n")
			leia(resp)
			
			resp = testeResposta(resp)
			
			c = responder(palavra, caracteresPalavra, t, resp, tempo)

			se(c == "dica"){
				contDicas++
			}
			
			erros = resultado(c, palavrasDicas, numSort, contDicas, tempo, resp, letrasFaladas, erros)

			tentativas++
			ganhou(erros, tentativas, caracteresPalavra, palavrasDicas, palavra, letrasFaladas, contDicas, tempo, somJogo)
		}
	}

	funcao logico desenha(inteiro erros, logico vida){
		escolha(erros){
			caso 0:
				escreva(" ___________\n")
				escreva("|        |  \n")
				escreva("|           \n")
				escreva("|           \n")
				escreva("|           \n") 
				escreva("|           \n")
				escreva("|___________\n")
				vida = verdadeiro
			pare
			caso 1:
				escreva(" ___________\n")
				escreva("|        |  \n")
				escreva("|        O  \n")
				escreva("|           \n")
				escreva("|           \n")
				escreva("|           \n")
				escreva("|___________\n")
				vida = verdadeiro
			pare
			caso 2:
				escreva(" ___________\n")
				escreva("|        |  \n")
				escreva("|        O  \n")
				escreva("|        |  \n")
				escreva("|           \n")
				escreva("|           \n")
				escreva("|___________\n")
				vida = verdadeiro
			pare
			caso 3:
				escreva(" ___________\n")
				escreva("|        |  \n")
				escreva("|        O  \n")
				escreva("|      --| \n")
				escreva("|           \n")
				escreva("|           \n")
				escreva("|___________\n")
				vida = verdadeiro
			pare
			caso 4:
				escreva(" ___________\n")
				escreva("|        |  \n")
				escreva("|        O  \n")
				escreva("|      --|-- \n")
				escreva("|           \n")
				escreva("|           \n")
				escreva("|___________\n")
				vida = verdadeiro
			pare
			caso 5:
				escreva(" ___________\n")
				escreva("|        |  \n")
				escreva("|        O  \n")
				escreva("|      --|-- \n")
				escreva("|       _|  \n")
				escreva("|           \n")
				escreva("|___________\n")
				vida = verdadeiro
			pare
			caso 6:
				escreva(" ___________\n")
				escreva("|        |  \n")
				escreva("|        O  \n")
				escreva("|      --|-- \n")
				escreva("|       _|_ \n")
				escreva("|           \n")
				escreva("|___________\n")
				vida = falso
			pare
		}
		retorne vida
	}
	funcao lerArquivo(cadeia mat[][]){
		inteiro arquivo = arq.abrir_arquivo("./jogo.txt", arq.MODO_LEITURA)
		para (inteiro i = 0; i < util.numero_linhas(mat); i++){
			para(inteiro j = 0; j < util.numero_colunas(mat); j++){
				mat[i][j] = arq.ler_linha(arquivo)
			}
		}
		arq.fechar_arquivo(arquivo)
	}

	funcao cadeia palavraSorteada(cadeia mat[][]){
		inteiro num = util.sorteia(0, 90)
		cadeia palavra = mat[num][0]
		palavra = txt.extrair_subtexto(palavra, 2, txt.numero_caracteres(palavra))
		retorne palavra
	}

	funcao tracos(cadeia palavra, inteiro tentativas, cadeia caracteresPalavra[], cadeia letrasFaladas[]){
		inteiro tamanho = txt.numero_caracteres(palavra)

		cadeia vetorPalavra[50]
		
		para(inteiro i = 0; i < tamanho; i++){
			caracter char = txt.obter_caracter(palavra, i)
			vetorPalavra[i] = t.caracter_para_cadeia(char)
		}
		
		se(tentativas == 0){
			para(inteiro i = 0; i < tamanho; i++){
				se(vetorPalavra[i] == " "){
					caracteresPalavra[i] = "  "
				} senao {
					caracteresPalavra[i] = "__"
				}
			}
			escrevaVetor(caracteresPalavra, tamanho)
			escreva("\n")			
		} senao {

			escrevaVetor(caracteresPalavra, tamanho)
			escreva("\nLetras já faladas: " )
			escrevaVetor(letrasFaladas, 24)
		
			escreva("\n")
		}
	}

	funcao cadeia responder(cadeia palavra, cadeia caracteresPalavra[], inteiro t, cadeia resp, inteiro tempo){
		inteiro tamanho = txt.numero_caracteres(palavra)
		caracter v[50]
		cadeia c = ""
		para(inteiro i = 0; i < tamanho; i++){
			v[i] = txt.obter_caracter(palavra, i)
		}

		resp = txt.caixa_alta(resp)
		
		se(resp == "DICA"){
			c = "dica"
	     } senao se(util.tempo_decorrido() - t > (tempo * 1000)){
			c = "tempo"
		} senao{
			para(inteiro i = 0; i < tamanho; i++){
				se(resp == t.caracter_para_cadeia(v[i])){
					c = resp
					caracteresPalavra[i] = txt.caixa_alta(c)
				}
			}
		}
		
		retorne c
	}

	funcao ganhou(inteiro erros, inteiro tentativas, cadeia caracteresPalavra[], cadeia palavrasDicas[][], cadeia palavra, cadeia letrasFaladas[], inteiro contDicas, inteiro tempo, inteiro somJogo){
		inteiro tamanho = txt.numero_caracteres(palavra), teste = 0

		para(inteiro i = 0; i < tamanho; i++){
			se(caracteresPalavra[i] != "__"){
				teste++
			}
		}

		se(teste == tamanho){
			sons.interromper_som(somJogo)
			inteiro somVitoria = sons.carregar_som("./somVitoria.mp3")
			sons.definir_volume_reproducao(somVitoria, 100)
			sons.reproduzir_som(somVitoria, falso)
			escreva("\n==============================================================")
			escreva("\n                PARABÉNS VOCÊ GANHOU O JOGO!")
			escreva("\n                VOCÊ TEVE: " +  tentativas + " tentativas")
			escreva("\n                PALAVRA CORRETA: " + 	palavra)
			escreva("\n==============================================================")
			util.aguarde(5000)

			caracter resp

			escreva("\nVocê quer jogar de novo? (s/n)")
			leia(resp)

			enquanto(resp != 's' e resp != 'n'){
				escreva("Digite um caracter válido!\n")
				util.aguarde(1000)
				escreva("\nVocê quer jogar de novo? (s/n)")
				leia(resp)
			}
			
			se(resp == 's'){
				escreva("\nVocê quer mudar de dificuldade?(s/n)")
				leia(resp)

				enquanto(resp != 's' e resp != 'n'){
					escreva("Digite um caracter válido!\n")
					util.aguarde(1000)
					escreva("\nVocê quer mudar de dificuldade? (s/n)")
					leia(resp)
				}

				se(resp == 's'){
					limpa()
					inicio()
				} senao{
					erros = 0
					tentativas = 0
					contDicas = 2

					esvaziaVetor(caracteresPalavra)
					esvaziaVetor(letrasFaladas)
			
					lerArquivo(palavrasDicas)
			
					palavra = palavraSorteada(palavrasDicas)
					limpa()
					contador()
					sons.reproduzir_som(somJogo, verdadeiro)
					jogo(erros, tentativas, caracteresPalavra, palavrasDicas, palavra, letrasFaladas, contDicas, tempo, somJogo)
				}
			} senao {
				escreva("\nAté a próxima!\n")
			}
			
		} senao{
			jogo(erros, tentativas, caracteresPalavra, palavrasDicas, palavra, letrasFaladas, contDicas, tempo, somJogo)
		}
	}

	funcao perdeu(inteiro tentativas, cadeia palavra, inteiro somJogo){
		//Se o jogador tiver perdido o jogo essa função será ativada

		sons.interromper_som(somJogo)
		inteiro somPerdeu = sons.carregar_som("./somPerdeu.mp3")
		sons.reproduzir_som(somPerdeu, falso)
		
		escreva("\n==============================================================")
		escreva("\n                VOCÊ PERDEU!")
		escreva("\n                VOCÊ TEVE: " +  tentativas + " tentativas")
		escreva("\n                PALAVRA CORRETA: " + 	palavra)
		escreva("\n==============================================================")
		util.aguarde(3000)
		caracter resp

		escreva("\nVocê quer jogar de novo? (s/n)")
		leia(resp)

		enquanto(resp != 's' e resp != 'n'){
			escreva("Digite um caracter válido!\n")
			util.aguarde(1000)
			escreva("\nVocê quer jogar de novo? (s/n)")
			leia(resp)
		}
		
		se(resp == 's'){
			limpa()
			inicio()
		} senao{
			escreva("Até a proxima!")
			util.aguarde(2000)
		}
	}

	funcao escrevaVetor(cadeia v[], inteiro tamanho){
		//Função responsável por escrever um vetor
		para(inteiro i = 0; i < tamanho; i++){
			se(v[i] != ""){
				escreva(v[i] + " ")
			}
		}
	}

	funcao escrevaDicas(cadeia palavrasDicas[][], inteiro numSort, inteiro numDica){
		//Essa função é responsável por escrever as dicas na tela do jogador
		//Será usada no início do jogo ou quando o jogador escrever 'dica'
		cadeia p = txt.extrair_subtexto(palavrasDicas[numSort][numDica], 2, txt.numero_caracteres(palavrasDicas[numSort][numDica]))
		escreva("Dica: " + p + "\n")
	}

	funcao inteiro encontraPalavra(cadeia palavra, cadeia palavrasDicas[][]){
		//Função responsável por encontrar em qual linha da matriz a palavra secreta está
		inteiro i = 0
		para(i = 0; i < util.numero_linhas(palavrasDicas); i++){
			cadeia palavraMatriz = txt.extrair_subtexto(palavrasDicas[i][0], 2, txt.numero_caracteres(palavrasDicas[i][0]))
			se(palavraMatriz == palavra){
				pare
			}
		}
		retorne i
	}

	funcao logico encontraLetra(cadeia l, cadeia letrasFaladas[]){
		//Essa função serve para ver se a letra falada pelo jogador já foi falada
		//Caso ela retorne verdadeiro o jogador irá perder uma vida
		
		logico teste = falso
		l = txt.caixa_alta(l)
		para(inteiro i = 0; i < util.numero_elementos(letrasFaladas); i++){
			se(letrasFaladas[i] == l){
				teste = verdadeiro
				pare
			}
		}

		retorne teste
	}

	funcao logico eDoAlfabeto(cadeia resp){
		//Essa função verifica se o caracter informado pelo usuário faz parte do alfabeto
		//É utilizado na função testeResposta()
		
		inteiro cont = 0
		cadeia alfabeto[26] = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}

		resp = txt.caixa_alta(resp)
		
		para(inteiro i = 0; i < 26; i++){
			se(alfabeto[i] == resp){
				cont++
			}
		}
		
		se(cont == 0){
			retorne falso
		} senao{
			retorne verdadeiro
		}
	}

	funcao logico temEspaco(cadeia l){
		//Essa função verifica se há um espaço após o caracter informado pelo jogador
		//É utilizada na função testeResposta
		
		se(txt.numero_caracteres(l) != 2){
			retorne falso
		} senao{
			caracter x = txt.obter_caracter(l, 1)
			se(t.caracter_para_cadeia(x) == " "){
				retorne verdadeiro
			} senao{
				retorne falso
			}
		}
	}

	funcao cadeia testeResposta(cadeia resp){
		//Essa função verifica se o caracter falado pelo jogador é válido

		resp = txt.caixa_alta(resp)

		inteiro somAlarme = sons.carregar_som("./somAlarme.mp3")
		
		enquanto((txt.numero_caracteres(resp) > 1 e resp != "DICA") ou t.cadeia_e_inteiro(resp, 10) ou (eDoAlfabeto(resp) == falso e resp != "DICA")){
			se(t.cadeia_e_inteiro(resp, 10)){
				escreva("Digite uma letra e não um número!\n")
				sons.reproduzir_som(somAlarme, falso)
				util.aguarde(1000)
				sons.interromper_som(somAlarme)
				escreva("Fale uma letra: \n")
				leia(resp)
			}senao se(resp == "" ou resp == " "){
				escreva("Digite algo!\n")
				sons.reproduzir_som(somAlarme, falso)
				util.aguarde(1000)
				sons.interromper_som(somAlarme)
				escreva("Fale uma letra: \n")
				leia(resp)
			}senao se(eDoAlfabeto(resp) == falso e temEspaco(resp) == falso e txt.numero_caracteres(resp) > 1){
				escreva("Digite apenas uma letra!!!\n")
				sons.reproduzir_som(somAlarme, falso)
				util.aguarde(1000)
				sons.interromper_som(somAlarme)
				escreva("Fale uma letra: \n")
				leia(resp)
			} senao se(temEspaco(resp)){
				caracter x = txt.obter_caracter(resp, 0)
				resp = t.caracter_para_cadeia(x)
			} senao se(eDoAlfabeto(resp) == falso){
				escreva("Digite uma letra do alfabeto!\n")
				sons.reproduzir_som(somAlarme, falso)
				util.aguarde(1000)
				sons.interromper_som(somAlarme)
				escreva("Fale uma letra: \n")
				leia(resp)
			}
		}
		retorne resp
	}

	funcao esvaziaVetor(cadeia vetor[]){
		//Função responsável por esvziar o vetor
		para(inteiro i = 0; i < util.numero_elementos(vetor); i++){
			vetor[i] = ""
		}
	}

	funcao inteiro menu(){
		//Função responsável por escrever o MENU do jogo e definir o tempo para responder(dificuldade)
		
		inteiro resp = 0
		inteiro somMenu = sons.carregar_som("./somMenu.mp3")
		sons.reproduzir_som(somMenu, verdadeiro)
		
		escreva("Nome: Artur Melo Favero\nRA: 1680482411045\n")
		escreva("Nome:Rafael Oliveira dos Santos\nRA: 1680482411032\n")
		escreva("JOGO[X]\n")
		escreva("DICAS[X]\n")
		escreva("CONTROLE DE TEMPO[X]\n")
		util.aguarde(3000)
		escreva("=========================== JOGO DA FORCA ===========================\n")
		escreva("\n")
		escreva("                            DIFICULDADES\n\n")
		escreva("                          1. DIFICULDADE FÁCIL (22s)\n")      
		escreva("                          2. DIFICULDADE MÉDIA (18s)\n")    
		escreva("                          3. DIFICULDADE DIFÍCL(10s)\n")         
		escreva("\nEm qual dificuldade você irá jogar?(1/2/3)\n")  
		leia(resp)
		enquanto(resp != 1 e resp != 2 e resp != 3){
			escreva("Escreva uma opção válida!\n")
			leia(resp)	                  
		}

		escolha(resp){
			caso 1:
				escreva("=============================== REGRAS ==============================\n")
				escreva("                  Você tem 22 segundos para responder\n")
				escreva("              Se você repetir uma letra irá perder uma vida\n")
				escreva("              Caso você queira mais uma dica digite 'dica'\n")
				escreva("       Toda vez que você pedir uma dica você irá perder uma vida\n")
				escreva("       Toda vez que você errar uma letra você irá perder uma vida\n")
				escreva("Se você demorar mais de 22 segundos para responder irá perder uma vida\n")
				escreva("=====================================================================\n")
				util.aguarde(8000)
				resp = 22
			pare
			caso 2:
				escreva("=============================== REGRAS ==============================\n")
				escreva("                  Você tem 18 segundos para responder\n")
				escreva("              Se você repetir uma letra irá perder uma vida\n")
				escreva("              Caso você queira mais uma dica digite 'dica'\n")
				escreva("       Toda vez que você pedir uma dica você irá perder uma vida\n")
				escreva("       Toda vez que você errar uma letra você irá perder uma vida\n")
				escreva("Se você demorar mais de 18 segundos para responder irá perder uma vida\n")
				escreva("=====================================================================\n")
				util.aguarde(8000)
				resp = 18
			pare
			caso 3:
				escreva("=============================== REGRAS ==============================\n")
				escreva("                  Você tem 10 segundos para responder\n")
				escreva("              Se você repetir uma letra irá perder uma vida\n")
				escreva("              Caso você queira mais uma dica digite 'dica'\n")
				escreva("       Toda vez que você pedir uma dica você irá perder uma vida\n")
				escreva("       Toda vez que você errar uma letra você irá perder uma vida\n")
				escreva("Se você demorar mais de 10 segundos para responder irá perder uma vida\n")
				escreva("=====================================================================\n")
				util.aguarde(8000)
				resp = 10
			pare
		}

		sons.interromper_som(somMenu)
		limpa()
		contador()
		retorne resp
	}

	funcao contador(){
		//Função responsável por fazer uma espécie de cronômetro antes do início do jogo
		
		inteiro cont = 3
		inteiro somContador = sons.carregar_som("./somContador.mp3")
		sons.reproduzir_som(somContador, falso)
		sons.definir_volume_reproducao(somContador, 100)
		enquanto(cont != 0){
			escreva("####->" + cont + "<-####")
			util.aguarde(1000)
			cont--
			limpa()
		}
		escreva("####-> VAI <-####\n")
		util.aguarde(500)
		limpa()
	}

	funcao inteiro resultado(cadeia c, cadeia palavrasDicas[][], inteiro numSort, inteiro contDicas, inteiro tempo, cadeia resp, cadeia letrasFaladas[], inteiro erros){
		//Função responsável de informar o jogador o resultado de sua resposta

		inteiro somErro = sons.carregar_som("./somErro.mp3")
		
		se(c == "dica"){	
			inteiro somDica = sons.carregar_som("./somDica.mp3")
			sons.reproduzir_som(somDica, falso)
			sons.definir_volume_reproducao(somDica, 100)
			escrevaDicas(palavrasDicas, numSort, contDicas)
			util.aguarde(3000)
			erros++
		} senao se(c == "tempo"){
			sons.reproduzir_som(somErro, falso)
			sons.definir_volume_reproducao(somErro, 100)
			escreva("\n==============================================================")
			escreva("\nVocê demorou mais de " + tempo + " segundos para responder!")
			escreva("\nCom isso você perderá uma vida!")
			escreva("\n==============================================================\n")
			erros++
			util.aguarde(2000)
		} senao se(c == ""){
		     sons.reproduzir_som(somErro, falso)
			sons.definir_volume_reproducao(somErro, 100)
			escreva("\n==============================================================")
			escreva("\nVocê errou a letra!")
			escreva("\n==============================================================\n")
			util.aguarde(1000)
			se(encontraLetra(resp, letrasFaladas) == falso){
				para(inteiro i = 0; i < util.numero_elementos(letrasFaladas); i++){
					se(letrasFaladas[i] == ""){
					letrasFaladas[i] = txt.caixa_alta(resp)
					pare
					}
				}
			}
			erros++
		} senao se(encontraLetra(c, letrasFaladas) == falso){
			inteiro somAcerto = sons.carregar_som("./somAcerto.mp3")
			sons.reproduzir_som(somAcerto, falso)
			sons.definir_volume_reproducao(somAcerto, 100)
			escreva("\n==============================================================")
			escreva("\nVocê acertou a letra!")
			escreva("\n==============================================================\n")
			util.aguarde(1000)
			para(inteiro i = 0; i < util.numero_elementos(letrasFaladas); i++){
				se(letrasFaladas[i] == ""){
					letrasFaladas[i] = txt.caixa_alta(c)
					pare
				}
			}
		} senao {
			erros++
			sons.reproduzir_som(somErro, falso)
			sons.definir_volume_reproducao(somErro, 100)
			escreva("\n==============================================================")
			escreva("\nA letra dada como resposta já havia sido inserida!")
			escreva("\nMais um erro adicionado!")
			escreva("\n==============================================================\n")
			util.aguarde(2000)
		}

		retorne erros
	}
}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 10584; 
 * @DOBRAMENTO-CODIGO = [7, 70, 145, 155, 162, 192, 218, 290, 324, 333, 340, 352, 390, 450, 457, 528, 546];
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = {palavra, 158, 9, 7};
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */