# Uniswap V3

 - Uniswap v3 é muito diferente do Uniswap v2. Embora os pools Uniswap v3 também tenham dois tokens e usem uma fórmula de produto constante (X * Y = K), o Uniswap v3 introduz um novo conceito chamado "Liquidez Concentrada". A ideia principal desse recurso é que os fornecedores pode fornecer em uma faixa de preço escolhida e implica que as reservas de cada posição são apenas o suficiente para suportar a negociação dentro de sua faixa. Quando o preço sai desse intervalo, a posição do provedor de liquidez é trocada inteiramente em um dos dois tokens, dependendo do preço acima ou abaixo do intervalo. Se isso acontecer, sua posição só é deixada com 1 ativo e não ganha taxas de negociação até que o preço entre novamente no intervalo.

# Liquidez Concentrada

 - O recurso mais inovador da Uniswap V3’, liquidez concentrada, é um conceito revolucionário que aumenta significativamente a eficiência de capital para os LPs. Ao contrário das versões anteriores, onde a liquidez foi distribuída uniformemente em toda a faixa de preço, o V3 permite que os provedores de liquidez especifiquem uma faixa de preço para sua liquidez. Esta abordagem focada permite que os LPs criem “positions” que atuam como conjuntos de produtos constantes com reservas virtuais maiores dentro do seu intervalo especificado, maximizando a utilização dos seus ativos e minimizando o capital ocioso.
 Isso significa que, em vez de seus ativos serem usados em todo o espectro de preços, eles podem optar por fornecer liquidez apenas dentro de uma faixa de preço específica. Essa abordagem permite que os LPs maximizem a utilização de seus ativos e potencialmente ganhem mais taxas.

 - A introdução de tokens não fungíveis (NFTs) no V3 adiciona ainda um toque único, já que cada posição agora representa um NFT com propriedades específicas. Concentrando sua liquidez em faixas mais estreitas em torno do preço atual, oos LPs racionais podem reduzir seus custos de capital e ajustar suas posições à medida que o preço se move para manter sua liquidez ativa. Além disso, esta abordagem inovadora permite que os LPs tenham controle granular sobre sua exposição ao risco e adaptem suas posições à sua tolerância ao risco específica e perspectivas de mercado.

# Fornecendo Liquidez

 - A liquidez no Uniswap V3 é fornecida criando "posições" de propriedade dos usuários. Esta mecânica difere da Uniswap V2, onde a propriedade de liquidez foi implementada através de tokens ERC20 LP. Em UniswapV3, uma "posição" é um objeto de propriedade de um usuário, detendo uma certa quantidade de liquidez mais uma gama de ticks (de tickLower para tickUp). Como pode ser visto, mint e burn são operações muito semelhantes. Em caso de cunhagem, a liquidez é adicionado para uma posição, enquanto em caso de queima, a liquidez é subtraído.

 - Suponha que um provedor de liquidez fornece liquidez em uma faixa de preço [pa pb]. A ideia principal do Uniswap v3 é que o provedor de liquidez a posição usará seus ativos para permitir a negociação entre os preços pa e pb. Quando o preço sai desse intervalo, os ativos de positionetts não são usados para negociação e, portanto, os saldos de positionetts permanecem inalterados até que o preço entre no intervalo [pa pb] novamente. Além disso, se o preço cair abaixo pa, então a posição do provedor de liquidez será totalmente convertida em token X, e se o preço for acima pb, então a posição do provedor de liquidez será totalmente convertida em token Y. Por exemplo, neste último caso, podemos pensar que toda a quantidade de token X da posição foi vendida como o preço do token X aumentou, e assim, a posição só tem token Y esquerda. Observe que, em ambos os casos, o provedor de liquidez fica com o ativo menos valioso.

**Out of Range**
 - Quando o preço de um token em uma pool de liquidez concentrada (como no Uniswap V3) sai do intervalo de preço configurado no momento da criação ou alocação de liquidez, ocorrem as seguintes coisas :
1.  Liquidez sai de operação ativa 
    - A liquidez que você forneceu não será usada para transações, pois o preço do par está fora do intervalo definido.
    - Na prática, você para de ganhar taxas de swap, já que a sua liquidez não está participando ativamente nas trocas.
2.  Você fica 100% em um dos tokens
    - Se o preço ultrapassar o limite superior do intervalo
      - Você ficará 100% no token base (token mais forte).
      - Por exemplo, se a pool é ETH/USDC e o preço de ETH sobe acima do limite, você terá apenas USDC.
    - Se o preço cair abaixo do limite inferior do intervalo
      - Você ficará 100% no token cotado (token mais fraco).
      - No exemplo da pool ETH/USDC, se o preço do ETH cair, você terá apenas ETH.
3. Reentrada no intervalo
    - Se o preço voltar ao intervalo configurado:
      - Sua liquidez será reativada automaticamente, e você começará a participar de swaps novamente.
      - Você voltará a ganhar taxas de transação.
4. Risco de perdas
    - Se o preço não retornar ao intervalo escolhido:
      - Você pode acabar preso no token menos desejado, dependendo da direção do preço.
      - Isso pode resultar em perda impermanente significativa, caso o preço se mova permanentemente fora do intervalo.

**Como gerenciar isso ?**
 - Escolha intervalos estratégicos: Baseie-se na volatilidade esperada e nos dados históricos do par.
 - Reavalie periodicamente: Você pode ajustar ou mover a sua liquidez manualmente para acompanhar o mercado.
 - Automação: Ferramentas como bots de liquidez ou plataformas especializadas podem ajudar a gerenciar intervalos dinamicamente.

 - Uma consequência da liquidez concentrada é que as posições são altamente personalizadas, uma vez que os provedores de liquidez podem escolher não apenas o valor a depositar, mas também o intervalo em que desejam fornecer liquidez. Isso implica que as posições em um pool Uniswap v3 são naturalmente não fungíveis. Portanto, os provedores de liquidez devem receber tokens não fungíveis em troca de seu depósito, e esses tokens LP não fungíveis terão que manter um registro dos detalhes de sua posição específica. Além disso, devido ao recurso de provisão de liquidez personalizável, as taxas agora devem ser coletadas e armazenadas separadamente como tokens individuais, em vez de serem reinvestidas automaticamente como liquidez no pool.

# Como Funciona o Uniswap V3 ?

 - Para compreender ‘como funciona o Uniswap V3’, precisamos de explorar as suas características únicas e mecanismos subjacentes. Aprofundando-se no funcionamento interno da Uniswap V3’, a fórmula constante do fabricante do mercado de produtos (x * y = k) continua a ser a pedra angular do protocolo. No entanto, a nova liquidez concentrada e as faixas de preços personalizáveis transformam a maneira como os provedores de liquidez se envolvem com a plataforma. “Ticks” são componentes-chave na V3, representando pontos de preço igualmente espaçados ao longo de toda a gama de preços. Cada tick atua como um limite de intervalo exclusivo, permitindo que os LPs definam seu intervalo de liquidez selecionando dois ticks. À medida que os swaps são executados, o protocolo processa transações em segmentos, navegando pela liquidez disponível em cada faixa de preço e ajustando as reservas de acordo, mantendo o invariante (k).Esse mecanismo garante que a V3 gerencie efetivamente a liquidez em várias faixas de preços, fornecendo negociação eficiente e controle granular para LPs.`

# Perda Impermanente

 - Perda impermanente refere-se à perda que um provedor de liquidez pode experimentar quando a relação de preço do par de tokens em um pool de liquidez se desvia significativamente de quando eles depositaram seus ativos. No contexto da Uniswap V3, esse desvio pode levar a que a liquidez se torne inativa se estiver fora da faixa de preço especificada, aumentando assim o risco de perda impermanente. Na Uniswap V3, os provedores de liquidez escolhem a faixa de preço para a qual desejam fornecer liquidez. Se o preço de mercado do par de tokens se mover fora desse intervalo, sua liquidez não será usada para negociações e não ganhará taxas, tornando-se efetivamente inativa. Isso pode levar a um custo de oportunidade ou mesmo a uma perda se o preço de mercado se afastar do intervalo escolhido e não retornar antes que o provedor de liquidez retire seus ativos.O gerenciamento ativo de posições é, portanto, crucial na Uniswap V3 para mitigar esses riscos. Os LPs podem precisar ajustar freqüentemente suas faixas de preços para manter sua liquidez ativa e se alinhar às condições do mercado. Eles também podem precisar retirar sua liquidez se ela não estiver mais ativa, para evitar incorrer em perdas.

# Ticks

 - Na Uniswap v3, os provedores de liquidez fornecem liquidez em uma faixa de preço limitada escolhida. No entanto, os limites inferior e superior deste intervalo não podem ser definidos arbitrariamente, mas podem ser escolhidos a partir de um finito (mas muito grande!) subconjunto do conjunto de números positivos reais. Os elementos deste subconjunto são chamados "ticks" e são indexados por números inteiros da seguinte maneira: eu ∈ Z representa o tick (e, portanto, o preço) p(eu) = 1.0001eu. Também diremos que o índice de tique-spacing para o tick p(eu) é eu.

 - “Ticks” são componentes-chave na V3, representando pontos de preço igualmente espaçados ao longo de toda a gama de preços. Cada tick atua como um limite de intervalo exclusivo, permitindo que os LPs definam seu intervalo de liquidez selecionando dois ticks. À medida que os swaps são executados, o protocolo processa transações em segmentos, navegando pela liquidez disponível em cada faixa de preço e ajustando as reservas de acordo, mantendo o invariante (k).Esse mecanismo garante que a V3 gerencie efetivamente a liquidez em várias faixas de preços, fornecendo negociação eficiente e controle granular para LPs.

 - Os Ticks são usados no Uniswap v3 para determinar a liquidez que está dentro do intervalo. Os pools Uniswap v3 são compostos de ticks que variam de -887272 a 887272, que funcionalmente equivalem a um preço simbólico entre 0 e infinito, respectivamente.

   - Observe que cada tick está a 0,01% de distância do seguinte tick. O Uniswap v3 usa inteiros assinados de 24 bits para índices de tick. Assim, o mínimo e o máximo preços que pode lidar com são
   $$ p\left(-{2}^{23}\right)\approx 5.07\cdot {10}^{-365} $$
   e
   $$ p\left({2}^{23}-1\right)\approx 1.97\cdot {10}^{364} $$
   que cobrem quase todos os preços possíveis no espaço de ativos.`

 -  Como mencionamos anteriormente, o Uniswap v3 é baseado na fórmula constante do produto do Uniswap v2. Lembre-se que em um pool Uniswap v2, os saldos A e B dos dois tokens, X e Y, da pool deve satisfazer a fórmula A ⋅ B = L2, onde L é o parâmetro de liquidez do pool. Lembre-se também que o preço à vista p de token X em termos de token Y é dado por $$ \frac{B}{A} $$. Assim, podemos expressar os saldos A e B em termos de L, e $$ \sqrt{p} $$ da seguinte forma :
 $$ A=\frac{L}{\sqrt{p}}\kern1em \textrm{and}\kern1em B=L\cdot \sqrt{p}. $$
 Portanto, L e $$ \sqrt{p} $$ pode ser usado para rastrear o estado do pool, e isso é o que o Uniswap v3 AMM faz. Note que
 $$ \sqrt{p}(i)={1.0001}^{\frac{i}{2}} $$
 Dado qualquer preço p, o índice de tick associado a p é definido como o índice de tick do maior tick t isso satisfaz t ≤ p. Assim, o índice de ticks eu associado ao preço p é dado por
 $$ i=\left\lfloor {\log}_{1.0001}\;p\right\rfloor =\left\lfloor 2{\log}_{1.0001}\sqrt{p}\right\rfloor, $$
 onde para qualquer número real x, ⌊x⌋ denota o piso de xé o maior inteiro que é menor ou igual a x.

**Exemplo :**
 - Considere um pool Uniswap v3 com tokens ETH e DAI com o seguinte saldos :
   $$ DAI = {40.000} $$  $$ ETH = {10} $$        

 - Observe que o preço spot atual é 4.000 DAI/ETH (40.000 / 10). Este preço está associado, via Equação 5.1, para o índice de tick
 $$ i=\left\lfloor {\log}_{1.0001}4000\right\rfloor =82944. $$
 Observe que o índice do tick 82.944 corresponde ao preço
 $$ {1.0001}^{82944}\approx 3999.742678 $$
 enquanto o índice do tick 82.945 corresponde ao preço
 $$ {1.0001}^{82945}\approx 4000.142653. $$
 Se um provedor de liquidez quiser fornecer liquidez na faixa de preço [3700, 4300], podemos encontrar os índices de tick que estão perto dos limites desse intervalo aplicando a seguinte Equação :
 $$ \left\lfloor {\log}_{1.0001}3700\right\rfloor =82164,\left\lfloor {\log}_{1.0001}4300\right\rfloor =83667. $$

 - Então, cada tick representa um .01% (1 ponto base) movimento do preço do tick com i=0. O preço pode mover-se acima e abaixo de "1.0" por pequeno 0,01% passos no espaço inteiro (−∞,+∞).
 - Agora, calculamos os ticks que correspondem a esses índices de ticks e aos seguintes, já que os preços que estamos interessados estarão entre esses ticks. Exibimos os cálculos a seguir mesa :

   Índice de tick = 82.164 -- 82.165 -- 83.667 -- 83.668

   Tick (aprox.) = 3.699.634 -- 3.700.004 -- 4.299.619 -- 4.300.049

   Assim, o provedor de liquidez pode optar por fornecer liquidez no intervalo de preços [3.700,004, 4.300,049].

 **Calculando**
 - Na rede principal, o token USDC ERC-20 tem 6 decimais, o ETH tem 18 decimais. No entanto, o preço rastreado pela Uniswap internamente não está ciente desses decimais: na verdade, é o preço de um micro-USDC (ou seja. 0.000001 USDC) por um wei.

 - Este preço é calculado calculando o expoente da constante de base de tick Uniswap v3 1.0001. Se o preço for 205930, você obtém seu resultado:

 - `1.0001 ** 205930 = 876958666.4726943`
 - Para ajustar esse preço interno a um preço legível por humanos, você deve multiplicá-lo por 10^6 (os decimais do USDC) e divida por 10^18 (os decimais de [W]ETH), que é igual a multiplicar o preço por 10**-12.

 - `876958666.4726943 * (10 ** -12) = 0.0008769586664726943`
 - Finalmente, você provavelmente quer o inverso deste número. O pequeno número que você acabou de obter é o preço do USDC em termos de ETH, mas geralmente queremos acompanhar o preço do ETH em termos de USD[C]. Isso ocorre porque o preço no Uniswap é definido como igual a token1/token0, e este é um pool USDC/WETH, o que significa que token0 é USDC e token1 é WETH.

   Isso calcula o inverso :
   1 / 0.0008769586664726943 = 1140.3045984164828
   A resposta é de aproximadamente 1140,30 USDC por um ETH.

 - Se você fizer isso Solidity, leve em conta que ele não tem números de ponto flutuante, todos os cálculos são feitos com números de ponto fixo. Especificamente Uniswap usa números binários de ponto fixo (Números Q), e mantém o controle da raiz quadrada do preço multiplicado por 2**96.

# Ticks vs Tick-Spacing
 - Ticks: Unidades de medida que são usadas para definir faixas de preços específicas
 - Espaçamento entre ticks: A distância entre dois ticks, conforme definido pelo nível de taxa
 - O espaçamento entre os ticks é determinado pela taxa de swap da pool (por exemplo, 0.01%, 0.05%, 0.30% ou 1.00%)
 - Cada espaçamento de tick representa um preço diferente para um token na pool. Alguns pontos importantes a considerar :

   - Os ticks são marcadores contínuos em uma escala de preço, similares a posições em um velocímetro.
   - Cada tick corresponde a um preço específico. O preço é calculado usando a seguinte relação: P = 1.0001^tick.
   - O intervalo entre os ticks é determinado pelo spacing de tick, que depende da taxa de comissão da pool.
   - Os ticks vão andando continuamente, cobrindo todo o range de preços esperado. Não há um limite máximo fixo de ticks para um par de tokens como USDC/ETH.
   - O número total de ticks disponíveis depende do espaço de tick da piscina e do range máximo definido pelos provedores de liquidez.
   - Para um par como USDC/ETH, o range típico pode variar de cerca de 1000 a 3000 ticks, dependendo das expectativas de preços e da estratégia dos provedores de liquidez.
   - Quando o preço do ETH aumenta, os ticks se movem para o lado direito (mais alto), e vice-versa quando o preço diminui.

# Tick-Spacing

 - Em geral, o Uniswap v3 não permite uma escolha arbitrária dos índices de tick, mas introduz o conceito de carrapato espaçamento, que, em termos informais, é uma medida da separação entre os índices de tick permitidos. Concretamente, apenas os índices de tick que são múltiplos do espaçamento de tick são permitidos. Por exemplo, se o espaçamento entre ticks for 5, os únicos índices de ticks que podem ser usados são os múltiplos de 5: .., –10, –5, 0, 5, 10,...
 - No exemplo anterior, se o espaçamento de tick tivesse sido igual a 5, teríamos que considerar a tabela a seguir e o provedor de liquidez poderia ter chotsen para fornecer liquidez no intervalo de preços [3700.004, 4300.909].
 Índice de tick :
 82.160 - 82.165 - 83.665 - 83.670
 Tick (aprox.) :
 3.698.155 - 3.700.004 - 4.298.759 - 4.300.909

 - O parâmetro tick spacing é definido e corrigido quando o pool é criado. Claramente, se o espaçamento de tick for pequeno, os provedores de liquidez podem escolher intervalos mais precisos, mas, por outro lado, um pequeno espaçamento de tick pode fazer com que a negociação seja mais cara em termos de taxas de gás, já que toda vez que o preço cruza um tick inicializado, novos valores para certas variáveis precisam ser definidos, o que impõe um custo de gás ao comerciante.

 - Nem todos tick pode ser inicializado. Em vez disso, cada pool é inicializado com um tick-spacing isso determina o espaço entre cada um tick. Espaçamentos de ticks também são importantes para determinar onde a liquidez pode ser colocada ou removida. Se houver uma inicialização tick no tick 202910, a liquidez no máximo pode mudar logo no primeiro valor dado pelo tick-spacing, que é 202910 + 10 para a pool de 5 bps5.

   Tabela 1. Relação entre taxas e espaçamento entre ticks

    | Tick Spacing | Fee % | Fee (bps) |
   |----------|----------|----------|
   |    1     |    .01   |    1     |
   |    10    |    .05   |    5     |
   |    60    |    .3    |    30    |
   |    200   |    1     |    100   |

  - Usando a tabela acima, podemos determinar o tick-spacing da pool diretamente do nível de taxa. Mostramos a porcentagem e o formato bps para esses valores, como usados de forma intercambiável pelos profissionais, mas podem ser confusos para novos usuários.

# sqtrPriceX96 

  - Se você já leu o código Uniswap v3 e viu variáveis que terminam com X96 ou X128, você se deparou com o que chamamos de notação Q. Com Uniswap v3 veio o uso pesado da notação Q para representar números fracionários em ponto fixo aritmética. 
  - Para encurtar a história, você pode converter da notação Q para o “real value” dividindo por 2^k onde k é o valor após o X. Por exemplo, você pode converter sqrtPriceX96 para `sqrtPrice / 2^96`.
  - O seu tipo de dado em um contrato de pool é `uint160`, isso significa que contem 160 bits de informações, onde o numero em sim é um numero de ponto fixo binário `Q64.96`, onde 64 bits dos 160 são alcodados para o lador esquerdo da casa decimal, e 96 bits são alocados para a parte direita.

  ```javascript
   sqtrPriceX96 ^ 2
   ----------------  = 291703993.119 
      2 ^ 192
  ```
  ```javascript
  1 / 291703993.119 = 3,428.13271
  ```

# Taxas

  - Houve algumas mudanças importantes na forma como as taxas são distribuídas ao comparar o Uniswap V2 e o V3. Na Versão 2, as taxas foram automaticamente reinvestidas no pool de liquidez e esse não é mais o caso na Versão 3. Na Uniswap V3, as taxas são cobradas separadamente do pool e exigem resgate manual acionado sempre que o proprietário da posição quiser cobrar suas taxas. 

  - O Uniswap V3 também introduz o conceito de vários níveis de taxas. O Uniswap V2 tinha apenas um nível de taxa, uma taxa fixa de 0,30% para todas as piscinas. 

  - Os provedores de liquidez podem atualmente criar ou participar de pools em quatro níveis de taxa:

    - 0,01%
    - 0,05%
    - 0,30%
    - 1,00%
    
  - Mais níveis de taxas podem ser adicionados pela governança da UNI se a comunidade decidir que há necessidade de níveis de taxas adicionais. Os níveis de taxas mais baixos atraem o volume de negociação, mas diminuem a receita para os provedores de liquidez.

  - Essa estrutura de taxas personalizáveis garante que os pools com características variadas, como pares de stablecoins ou tokens altamente voláteis, possam otimizar suas taxas para um melhor desempenho do mercado. Por exemplo, os pools que trocam ativos de baixa volatilidade, como stablecoins, podem implementar o nível de taxa mais baixo, já que os provedores de liquidez não estão expostos ao risco de preço e esses swaps serão motivados a buscar um preço de execução mais próximo de 1:1 como eles podem obter. Ao oferecer diferentes níveis de taxas, o Uniswap V3 atende às necessidades de uma ampla gama de usuários, incluindo traders casuais, arbitrageurs e investidores institucionais. O resultado final é um ecossistema que equilibra os incentivos à provisão e negociação de liquidez, promovendo uma dinâmica de mercado saudável e crescimento orgânico.

# Resumo

**Por que razão foi introduzida a liquidez dentro de limites ?**
  - Permite aos fornecedores de liquidez obterem mais comissões sobre o seu capital. Fornecendo liauidez apenas nas faixas onde os traders estão negociando. Agora na Uniswap V3, você pode especificar um intervalo onde os tokens serão negociados.

  - Pode ganhar o mesmo montante de comissões, mas com um montante muito menor de capital para liquidez.

  - Ajuda a aumentar a eficiência global do uniswap, uma vez que os provedores de liquidez podem concentrar seu capital em uma unica faixa de ação de preço, mais liquidez estará disponivel para os swappers, o que significa que a Uniswap terá muito valor para capturar, e serão capazes de aumentar os volumes de quantidades para trades, além de aumentar o volume de taxas.

**Como isso é realmente implementado ?**
  - primeiro, é precisso compreender a noção de TICKS.

**Como é que decidimos quais são os Ticks?**
  - Bom, cada tick segue uma formula, que é `T = log 1,0001^(p)`, isso afirma que cada tick corresponde a potencia que você tem que aumentar de um em um pontos base, o preço (p), é um valor arbitrario. Portanto, para cada preço arbitrario, há um valor de tick que podemos usar para aumentar um em um pontos base para receber o preço.
  - Isso poderia ser restrito a `P = 1,0001^tick`.
  - Se quisermos obter o preço que corresponde a um tick, tudo que precisamos fazer é aumentar um em um "bases points" para cada tick.
    - Exemplo : 
    - Pegue um tick de uma pool (Ex USDC/ETH é 194922)
    - `1,0001 ^ 194922 = 291.696.797,189`
    - Aqui temos o preço de um USDC em termos de ETH (291.696.797,189 USDC é um ETH), já que na pool, o token0 é USDC.
    - Então agora pegamos esse valor de USDC em termo de ETH e invertemos, para encontrar o valor de ETH em termos de USDC.
    - Sabemos que 1 ETH é 1e18, (1 unidade com 18 casas decimais)
    - Dividimos 1 pelo valor em USDC, e dividimos por 1e18 `(1 / (291.696.797,189 / 1e18)`, logo dividimos por 1e6 (decimais do USDC)
    - `(1 / (291.696.797,189 / 1e18)) / 1e6) = 3428.21`
    - Valor de 1 ETH em USDC é $3428.21

**Obtendo o preço real da raiz quadrada do preço na variável qrtPriceX96 :**
  - O preço de um pool se parece com isso `sqrtPriceX96 uint160 : 1353165045894114495582256047512386`
  - A formula que calculamos isso é  (`sqtrPriceX96 / 2^96`)^2
  - Então : `(1353165045894114495582256047512386 / 2**96) ** 2 = 291703993.12`
  - `(1 / (291703993.12 / 1e18)) / 1e6) = 3428.13 USDC/ETH`

**Diferença entre Tick Atual e sqrtPriceX96 :**
  - Diferença entre Tick Atual e sqrtPriceX96
  Embora relacionados, o tick atual e o sqrtPriceX96 não são exatamente iguais:

  - O tick atual é um número inteiro arredondado para baixo.
  - O sqrtPriceX96 contém informações mais precisas sobre o preço atual.
    - Por exemplo :

    - Tick atual : 202919
    - Preço calculado do tick: ≈ 648962487.5642413
    - sqrtPriceX96: ≈ 649004842.70137
  - A diferença ocorre porque o tick atual é arredondado para baixo, enquanto o sqrtPriceX96 mantém informações mais precisas sobre o preço real.

**Como funciona o provisionamento de liquidez nestes intervalos de ticks**
  - Após criar uma posição com tickLower (Tick Inferior) e TickUpper (Tick Superior), então toda a liquidez que é fornecida será basicamente dividida entre todos os intervalos de tick individuais, então teremos o mesmo valor de liquidez em cada um dos intervalos de ticks.

  - Então, quando os swappers movem o preço na pool, ele cruza o limite da posição criada, começando por tickLower, e tornando a liquidez ativa. Então para cada tick subsequente em que o preço se move dentro da posição (Limite de ticks), a liquidez de cada tick é capaz de ser usada.
  
  - Quando acaba saindo da posição (Limite do tick), a liquidez é desativada, e sua liquidez total, é totalmente convertida para o token que sobra na pool (o menos valioso).


