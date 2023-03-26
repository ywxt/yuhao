-- Name: yuhao_char_filter.lua
-- 名称: 常用繁簡字符過濾腳本
-- Version: 20230312
-- Author: forFudan 朱宇浩 <dr.yuhao.zhu@outlook.com>
-- Github: https://github.com/forFudan/
-- Purpose: 從候選項中過濾出常用繁簡漢字
---------------------------------------
--
-- 介紹:
-- 字符過濾 charaset_filter 在鼠鬚管中不再有效,因爲 librime-charcode 被單獨出来作爲插件.
-- 所以我寫了這箇 lua 腳本過濾常用繁簡體字 (通规一二級 + 國字常用字 + 部分古籍通规字). 
-- 爲了允许標點符号，我把它们加入了字符集中.
-- 用户可以在 str 變量加入自己想包括的字符.
--
-- 功能:
-- (1) yuhao_char_only: 過濾常用字符,且不顯示其他字符.
-- (2) yuhao_char_first: 将常用字符前置. 原因:在某些形碼碼表中,全碼單字(生僻)會優先於全碼詞語(常用),開啓後可將全碼詞調整到生僻字前面.
--
-- 性能:
-- 經實測,關閉預測功能後不會影響性能;開啓預測功能後,老機器有可能有延遲.
--
-- Description:
-- The charaset_filter is not enabled in the Squirrel as librime-charcode was exclused as a standalone plug-in.
-- So a lua filter would be helpful to filter the frequently used characters (GB2312 + 常用國字標準字體表 + other characters).
--
-- 使用方法:
-- (1) 需要將此 lua 文件放在 lua 文件夾下
-- (2) 需要在 rime.lua 中添加以下代碼激活本腳本:
-- yuhao_char_filter = require("yuhao_char_filter")
-- yuhao_char_first = yuhao_char_filter.yuhao_char_first
-- yuhao_char_only = yuhao_char_filter.yuhao_char_only
-- (3) 需要在 switches 添加狀態:
-- - options: [yuhao_char_only, yuhao_char_first, utf8]
-- states: [常用字過濾, 常用字前置, UTF-8]
-- reset: 1
-- (4) 需要在 engine/filters 添加:
-- - lua_filter@yuhao_char_first
-- - lua_filter@yuhao_char_only
-- (5) 需要添加以下代碼防止符號不上屏:
-- yuhao_char_only:
--   tags: [abc]
-- (6) 建議關閉預測以提升性能, CPU 性能強大的朋友可以忽略本條:
-- translator/enable_completion: false
---------------------------

local str =
"意偏磊撓蹬祿驚紐髮隨朝惡先力渙垣徬壇艇衰倔酬輝耕倚餿氤鰓耍婁褐釜靜惆狠箴奶銬肺趾掀寵辟玄乩扭遮氾咸鍛遐實森稔綑薯休包帚幟佩裡矇臆豈魷柴鬧誌囂繚輿印戟古紡桅纏任壘朵煮治糙聆話伙騷悶艮透草燎保絮沒猾痊殊愁借吧季莞晶楠蓬氧稈推過蒲杷奔欖址哀囀徵旺爪疑轍上禱交扣禎魘鏟亡租男簿彩氳瓷蘋塢暉孀督紙準培危巾慘憎蜘堤床痙隍颳狼轉獸春僚蟹輟鄧酊欠澗燕鑑按骷淘觀蟀俐狎耗麟苓測冠悉史倏萌嗣嘻迢還榴髒儘匱悄峻副逼株遁埤鹼琊皴惋圈障佳灸甄瞥誕簞霧村溪湃會羽惕房挑兆拇翎笙處貌摩度吱稜課匯碾螳跌人雋褓棘連芬卑屯遷僵嘆睞料擾爍躇冉鏽籃肘諭呱樸閭采巷碼肴針厝擔韃夕鱷出毒墮婦鱗恿腋脊傭咀牆倦敞腰溢昆喻洞妥辱殲泄丫咚告形盔蹈證慫鴣餡柳鱸攝嵐堅捏譎女愴栽殃唉蒼髦浦醣楫蚣畦咬鷓七綺玷妨忠晴麋憬呶採舛領琍浬晚無句娟悌垢糯躡敝噓湮氮諷漁狄竅隘娠涼嬋滋夷履腔莎鏈備虜拭貿輒偵凳啕客腮揩尚御弩酋咕閡拉敢綱戴魁白裨冒裹蓋策吭門弦蝗摔姥刮稅哎嚶瀋冷廖溶牡燙高漿蓿也轄詢閨擦幗激斤憶崛揀焚嬰綜廬肥棄沙凱犬供躑帳姜益忿綽謝淺贓陰絀齡嶺蹂璃鮪傍嘶惠逮駛煽顆匿貴金嬤斂誅痣叔勤憚濘酥閉弊獎棒就役行堯猖撻軼象貓崙合摟粽贛鉗同增啡沉錘笞鏘吊詰岱眠未藤杵腕睬怡仇典盥加場煩卡吁躲雷漪盲杰浩割小搏仲抵砂紜貲樺磯少僑鬆歌符麴戎瑜藐屬仍楷聲捩龍暮各甕爆皺賣莫戮錢宣甜皇匕櫥扒煤騖挨酵陪悟於搔局豔鷺侈墅裸擄誡傻熙拙嚴息墾胱靖跛郡便土品幼擇善紹妒謁恥字盎寓站憊菲鬃皚默懊惹余容乏興綴儔菠廓迎碳捆幣蔡俸國蕊鮮整毋栩襪兔矩路每吃覽伸櫃哼帝獵煎凋線餃掌瘓蛔貼賤輔喪奢眷壕礪怵諾努戲敏藩事仙患拐掩存輸梯述瀆愀彙俯懵渣沛管斜殿綻惶莒坐險鳩疾贗杳繫姑舶臼薇豁嚅肯驀缽社簑毫琶眩刻兇套頹角筍予臘隆敬阱隊碉毀梗晉灘丕几狐拳申勵勝噩喇嬝呀富峰捶泰冕涇送赧噯餓悠夭卻猩艘丐虧訕陋者栓鵑熬竄姆孵柔花遇爵糧坊曆放旦悍皎覦摑迷叛踏濤瞟如娶建威勘胥拘嗽脆抹似淤錚肝瓢雅框釘霎入盟賂氫蔭犀宸揖強籬飧後親肖盡嘩性辨賺宋籍果伶俠墳幕啼疼翰郁靛署歿占非侖哺淵慌裁磬禦逝靂伍活赳欽亟抑糠沽飯撥僧幌炎韓倒霆亦貧鯨遍彆四弔喉皂已環見重殯董鞠格向困晝曉歇概臀殼解躺俎蔽塹蛇洋指攙塊盞紊爻閑汕姣康氣嬴俑羅舒腑壽烘鞦檔懶軾坍崔痲傀睏橢騫積尺惘翁寞妹睨發值越呆埠愈扛羯項種通藹彼熔妝腥企疊葫琳淮濂曖衙嘈掣匣侯考以襖猥聿克呼執丘叱世悚鈍物邑換窈戰務宦憂給謙護爐稍宏恣糕甦秋植腿款綁鐲姐麓唳噢吾漩戚岑禮疲統闊鄰題離躬陀雪蹊伏霜俊攘皮饞喟蠅悲溉紮萃佛配切沃翠某茵劍靨故林器共拄漲遞範彤翻誇雁籐摒試渤權決遽主恰噹藉且蝶歉蕩緻罩轎潤儼陳拈氓礬絃士硼逅雹尾虹麼讖熟炙痘篙覲駑媳柿遂窘鵬憤掛扮暖炭批我構弁炫狹義瀑消蜃倍絆宅欲饜罵悔撐哥綸樅胃志內官橫炸辯釣奚粒船贏棚潔穗櫛娑顯學姚雙宙愚理蹣霍匪辛潘庵冶粟賞鶴癮顏泡磁受固察暴弭政荼迭微炒飄聚承規鯽捻鐺期岫仕宮晰撇槐喳沅梁斟及撕愧既圖棕班集炳綰獲間叭喧嚷咐據拼坡收礫倆剩谿違恕鑲玲求貸啞賈滲摧蚊爺岸甥陝覓損講齋膝守啊煬鎊鐘窄氟梨騎恪胤轡醃衝咋婆豬踵肚華掃榨嚼樹捨遨快卷部燦急畚茱鑒之牙哪疳痱招閤夥瘧盒壯蒐弗查篇愜頗扼焙凶猴邂倩球布瓦伉追約晒偶踐遭子辰細景凌湧串徙巔颯窗彌橇毯襯櫻耳坷旭菩菽邢需硯颼寢授當瘡笆諸歧普惴漳焰芻盧膽跪歪謀祖艦汽閱安驟崎狩汨舫鈕隋瓏哭涮漬圳曰斃馮州苑校朔舢耶餐置啄斐買峨棗甫淚至弱徑摸斯瀛苛袍夙訂菁驛勉完瀟束媒瀰窒訐躁軀選咦慄緒羔誤聳鴦嚕裘驢糜奈妻滴挽價真碑要酷芽壑繞歷踢散審怒嫦恃扶宛煥笨震伺鴨店手傢縫股羹蘿蛙踟演南覬巫璣湛壞皈參併霞屁挫甚蠍譽攜胚楊禁燈這萋耿銅蛻廉鄙逢光熨躊悅屑滅庭挪爸牛舌誰徹蚱鵲斬崖亂介霸呂畢奇尋眺繼丙炮錦囊膿像技浴阿泉梵篤組原撩頓域脣箕淋膾薔徘偽蒙端蹤咫示蠱昏淇牒方著鰭好犄抉念獐朧一焦傳歸朗簍咽酸鐵雇雛庇嬉簽稱霓擠謂蝴甘黠擺佣滯唷珮繩嗷謗蕃蓓鈸錄澡荻噥尹頑噗馴援諂丑梆雯系偃濠埋拜祐奪播櫚蓉恫否惜舀鍬墨嵌囪排屏揭爛艾跋論蕈睦奎江薄級碰醬留覆倉繪撚蹦所瞠擱檜薑賀桀燭此薰舂沫駙郵忝擎轅仞瑙磐繆賁燧騰服寒鄭奠剋鋁節落械兢羶蓄振卯螃盛躍囉縷飪齒鉀鷗膚犛宵條袱馱嬪玫慧希幫雀髏書牢彰妾干嘀祇縣粳琵肢怕膺薩痛瑯賽鑽飼咄咪阜巒豪更拍癩鬼愕東翡片淙蟒赭箱夫輯妙盹唐掙跳崢年竹芥汐泊濟鈉木動奮頤黃摯飢儷沾穀左札窕塭娼淡噪宜袖輕久鋅全聖座楚儲回矓報懼帛吆恙儒惺抖詮啪飩俱唬厲昭茉老匡暫勻恩桿現萼綏謠嫁鸞嚮救駭賃瘟目椎芭叉儡設難疫媲扇峽汁箝襟鄒楞鵠夸于焉府紋舐候呈澈膳找融獰怏它旋腹夠吼類午葵誨閻狽咳驕曠罄裙躅棉澄鶉柵賄穢團慚智倫喔佯紉翹蚩豚倪竿係哩秤啖剁嬌丸祕哮瑪制自瘁鄉讀葷李蓆羊臺咒谷較邱劣闈洽漣思瞿徨褥叨軌燒廊頁鬍視妃喲孜番痢莉蝌揆刁體脈峙仿軛惰卉依后隔橘盆荷哲末罈距廢風京藥軸黯閒匈層攆衫涉樣缸譁際轟抬廿漆用直基鉻司慨跺超兩矯募掏譜進垮酣藍飽麝瀕莽嘉磚鬱夾漏晏蚯孕泳脖紅例魚喘夏貪逕筒爭愛僥畏睪茅襄螫友亨明慈湯贅羚徐對閩彝結蹋婿瑟鵝塚鱔紀匹抿棺正鑿糞贊撈珍碧搭擴召杏戛渭芙澤勞懸灼嘲疤罐松褒籠淒剌羞邊頸瀨綵岳析驥臾雕願宿丹螺剃奧館厄匙翳多遊族濁艙乓個坎埃矣肩譏賜鋼堆駿俺妳蒸韋鬨儉冑猿胸程霑卵抗荐口梅委胖鑾鞏堡境嘮瀝磋菌貝悖旗瀾亥杞闡鈾食別奸剔扔釁嗅仁騙駐閣啤聯浚嘖酩蝠蠣黍乳榻梳戶馥翔佇名熹逗遲慮筋膛攻星滌煉疵譯膊地吋斷玩死壁枴嘎汗說蟑餵瞻寮慎腆敗壓諍仄奉砥骼吶丈榜穌央諜亞秀寫箋允簇欄大何群痰鼠攣銳蓀酪昨再揮褶恢彈灰初邀爬哨陷山西弛極樽鈣泌禹室即掠習壬塗舅詞駁魏充熱柯鯊專靈蹉辜硝蔓偉罷醜六揉箔敘茸在埂射兼塞彿罹勁閔殮豌瘴舔晤鑣與弟潭嗟請鱉減汪私騾孔暑犧瞎衣訝露盾拷帷噸伴縱蚓澹鋸餌芍螢和將辭劃博壺驗警塔硃荔鸚萎芒逆瑣估綾腫餛壢談濺敵砰晨佐桐費璋倘皆喀擰漂昂判啃磺跡陌讒擒庚近淆圍築划喊城泥相胰腦造鋪籲誓助應侶唱嘰沱移柚癒哦零照砍鳳詫鴒剖輻撿矚篆墜具肌膨紛陸影詬添滓鹿券盯浪修郊尿締祭諧利裝駝糾另舜陡仗日簧搖舊靠池癸天跟怖搗匠弼般攤桂嫡篩忘井順蔚颶田顱月有桔刨尬隅祟夢嘟核嗓道嶽蟋灶曼怨仰鮑膏蜂擁異穆逞頰遜王楹輾腳家佝粗虐蜿釋嬸遴祝湖樵淹蛾乙忙模玉謎鈴坪盃飲瘤能姦父煌縮邁賦秣鰻哇壩屢臣菊財失法溝桶百樁輓擻懈悻軒記畝五圓刀寥絡韆丞孩憑懂柏烤脅途韌捱歟禪肪催延憧蝸註酉棠惟怯沮穹莖衡硬攔窪豎孫譴淑那黝盼渥撒姿墓探拔枚喋胎喃感諫是朴嫵令梭涎芝涸災簾兄唧波縛而掄嘴流稽蜜傑豹退頒立橄閘藪弓邏棧健販蜥了灌嚥蛋扯釀渲源嚀福純憾運眉冽畫喂憲贖瘀身潺疝戊羌咎二穎欣關君式唔逸磕握湊拋認賑優纜很詭蟻姨枸情穴戀拯他甸鐸沖撞炬衢鴉爽俗鳶黴憐甩堂礦刪霖吹娘濫缺酗問阡颱濃觸三毆譬侏跚米啾嗯溫杭睡茲惚凍傲做揍號貞材返紳搓揪洶踹登括槌酒良鉛空業川計謊緣絞耐梟矽伊破遺變茶墟麗扉鞘沿寶尸遠坤齣時羨滿姍取愎蘑吻嘹顰渴鄂閂簣溯嗇伐匾癢診佔鞋嫣牌鬚尉然衛孽忖漫膠殉丁蘸矮兀舍婉囈你術腺隴龐易北精訥元苟豐壤寂慢殆瞞錐葛拆必癲練織蓮都暨臥嫘獗疆深翕蜈絲血踱轂馳驃聾訣婊岌涕釵斥坦案右涵娩殷詩烏馬劈沌瓣只蚤措菰屜鍥差槓砌脯腸舟骰訴兵婀韭嗎妮賭曳尊洲雍膀呵晦煙么擲症笑彷萄悴鏡咖響嚨魔吝迴迪硫密去從揣派卦傅扁乎勸競倣鐮吟岔椒樊淌猷濯癱英蜀泣寬拂賓賬邇娛音停鍊韁蟯垂首搞蒂軋乘寸膜儀免祺淅枯恤廠彥茹啻蔑勿廝葩竣楓廟台靶稟坏票塵賒工噬持蔔噴穫輩邸嫉鼻確槽嵩暈吩旨榆虞諄迫窮髻胡癖鹽蛄裳單浙瀏作琴姬尖闌躪咆跨乞孝鎔削焊曝抱溼嘍瑩紇豆奐旬輪圾辣邪野旅婢朦蘆佾囑殖慰商渺互尷捎代載迂叢啟圭諱毅鍾鬥抄諮寧答牠趴稿汙瞭瓶鍍絕律致映祀乍擘摘炊姒盜昌下磷又蟬宰漾赤麒茫軍徊俚港踩屎嗚庾始帖痞瑰協齊豫詆周素饑濡汀可契敲筆怠量累表帶鞭頻醒呷廚槍茄最檸迅帥豕訊瓜猜韶矢凜來巖氏姓版由拎讓漱齦征捐崁牲亙面廣付偷昧曾龜潸監鳴燃枉泓懇厥型翩島獅粱薪混嘔柩餅哄蹶琅杖縑帆討詳雖纖牧穩含簫遑卸柄戕逐接凡鑼摹贈乾繅唸鼾戒闢云水嚎的誠員塾漓煞禾蕭扈屹寨犁板撼瑤職趟噎曦餾香突茁把叵庠忍濛闖搶鞍比妖唾赴列蛹耙鏗謹市苦懣憫況燄籮不懺燥醺革准嗡墊澳肉汝垃胭份艱鎖魯筵為虎錶頭餞趁鴛梧特躂猛冤畸使悵碗悸銜翅逛柬件掖刊瞳額往滬偕促降蝨翌染鑄鉸琢璽噫托搽銖虔篾誘其均哈黨複犯抒編擋踴柑青跼戾孳評恍操棟崑住廂羿鍋侮鏢定瑚佬岡緩棋羈蔗桑妤武舞嫌箏張悽長綠翼啜太滇繹獺貫隸顎嗤喜詛信橋稼製慕翱甌附獷沼螂引假吒芋檬舵納緯彪諒饒髭梓黜臃展妄遣濱叟兒虛冥冗蚪補起斗踝蒞侵屆睜蚌狂飭訟駕剛杉瞑詣塑幸莊奴笠率糖抓續赦車笛檳肋樓恐兜外峭噙駱娜窖沐廷徒攪旱溜濬猶鋒冬才擅瞌僭文若彎粥睥渝平禽朽祈清庶餉媛劫臚臟荀瑞屐避侍悼拖雉糟耽適涓剎戳趣烹位梢熄玻藏隧懦碌蕨痺繕揚藝勃今母濾蜓鈔蠶貽升嚐屍網杯頡潛逍謨蹲庸電髯瀉描醋遙溘臨訪秉嘗刷奄略議蝙殘踫狡頌麵纓購伯拱眼河聶滑繡晌搬次泅囚萸喬蒜拗菱樞藻低擂冢夜責盈繭芳茂帘九恨生繽殤披售迄顛因押緘苜烊罟罔銘婷洱蘇幹賊鱖渾嗜秩斧丟章盪訛茗睫巡石寄童媽盤謄教孰聞闆疏唯伽汲淪詹劑維娃噤砸褻傷該孤標珀骨嚏吵紫皿窟抨吐嶇撤雄臂訃礎睿逃惑塌育漸姊恬劉疹匐莓賠緬屈永坑鷹勒限歲嫩陣潦瘍銀逾帕萊矜燜亮偎錳暇祉望旁什樟怎靄冰葦歐宴心煦鵡彬民禿須劇挖淳狸懾辮膈訌拌她戈鰍咻慾俄朱託院壅瞪反甭半溺幻郭藕椅眨慶牘卓褂俘根亭喚攀籌辦呢綢闔吠黔肇省折聰隙瀚洗駢罪宇呃苞驪犢寡幅仃皓絨嫗橙敦赫刃箭肛荊睽鳥命臻懲鑰雨磨新甲簡呎姪蚵鋤前巨癘吏味開功鶯澱娓襲蕉罕菜咯葬桓榭琺預幾戍啣訓屠霉拚瞇滂黎蠢粵痕漕輛炕訖竟拒支封貨囤朕廁忱獻終暗識朋妓騁攬錯恭怪龔楔潮瞬兮吮鏤態燬中足陲棍暢雜烈垠腎栗邵但吳蟆畔孚甬凝吸寇鐳區螞釦蘭勛匆婪佑絢弧眾居氛復捧蕪爾鼓您臭覃弘棵佃達黏嗆沈匍霄曙病聘拿跎投脫烙宗顫效盂馭滾迺嘛啦嚇拮礙賴閥洪澀苗炯穿鎂總祁蹄調叼化檀磅趕嘯鈞爹芹醉除陽叫剝絹竭閃究火鴿阮瘋詐貶譚淫蕾冊頂崇釗捷泛蔥齲瘩傾欺段渡機瞧勢瘸灣許跆孺灑麻枝疙背裔醫岩縈嶄骯窺則卒忽繃隻油氨撫敷孟貯巢鴻幽哉廳挾毽曹棲胞苔神讚步萍紕蛛誼琥蟲匝摺莠菅蔣鎮醞隕吞凸瘦邐腱雞裂己掬喝禍奘麥提捫靦掘袒邦凰毓並浸胛舉被褪導言蔬拾施驅游函界得狙褲獨享衷卜觴待索嶼脂耀鉤抽矗珠禧妞杜窩枕儂秦媚插蕙頃旌注釐臍質巴燻賢湍肆錫靴海熾裴庫圃園寐萬枇營泱塘妊科緊或榷經蠔鷥颺蠟熊璧碎蹺迦簸氯蹙鹹捉咱搜仆數梔竇養槳竺堵筏婚袞瑕諦乒擬槁勾帽本桌色餘撰瘠肅忌崩眸軟想脾撮債慍菸湘魄短卿美僱瞰繁早航俏膩蛤陛誣骸姻篷雌鵪罰榮卹速沁潰袋資簪頷牟祠檢渠扳遼癥等魂軻幔蠡髓公害吉嫻彭液蛀跑飴倡檻漢烽奏藺囁慟葡償琉范殺瞽負稻懿階霾看飛緞牽蠹裊詠奕趨壟分填糊洛聽俞農嘿攏恆巍序飾渦靡鍵娥側蠕葉斑紗趙億酌孿乃僻漠成侃兌唆循遵鑠柱些勇毛廈堊霏剿捂蜢潑稠蝦紂席產研尼滄琪睹狀偌荒醇纂到貢蜻籟呻刑怔療覺凹衍德掉蘚澆碟刺算籤憔蠻諺師銓餒語擊浮簷尤窠隱綿厭控弄扎鼎常癌叮拴錨挺耘滔嫖創蛟寺樂捲第懷彗里袁屋防劾千徽嫂莘憩點底惻渚韻馨囌霹澎緝雲顧稀涯褫歹鬢陵惱竊仔饅祥慷妍遏筐淨打矛腐襠詔撲叩倖聊袂黛胳獄阻慣歡攫汰椰止狗剪蝕靼燉八鴕榕愿截街魅乖們僅敖蘊疇堪耆愉榔窯粹惦週肫秧謬愣鼬巧礁碩瞄誦迥駒痔筷蜴幢曲績橡噱疚裕厚知釉埔瓊替稚畜晃昔瑛羲郎貂秒傘冀十脹架黑僕沸痴桃臉螻薛走津銷阪陶鯉嗦拓捕改眶粉闐睛珊垫乱潼鱿逊叁暹仅挂啐璟碜鹘欧秽闻顽猝迈礼颈酝黄屿样崆绘嘣喏输币驭础谗楮倨祎览砚谚抻惨积贵寰亵颓趄独灾岁颠滥偿穷锄构砺辫内乡砖毗肾沣峡窜吓伎赃捡课揄对挥队乌呸额旖辗万爷咣针镀暂诡噼衩呛荦弑详择嗔忒俭歆悦实莱夹叶鲲伞勋账蚂瑾鸠传鲨枣贤哆牺继淬澜幡馄阕捍茜苍讹栖匀条睾冻脑驻鲁飙疮幄乜衮徇赚墩臌洼赣惩鸿惬见厌咨举馗檐嫔贻桧谭斓场唤琼苏矫桦恁缀丢轰绚挞彦个佞僖锲鱼岐陈铜鲤琨韫辎憨鹅诽蒯盖搅绍玺彻闭师魑贡统审镣锦篑访签风厨粲缩樱拣缪弈预堕镯戌龙辙庆阀语虱佶侦废腾鹊炀倌钩综渊刹凉竖苹侥忡骇舰鞅泸烂嗒厘鳌锋劳膻辐绒顾宾浃渐锵须洁骆娴庞贞国婶载逵纸鞑炼简狈怂苇锐夔繇宝钞哂亲蜕辽库亢忆晟桥婧灭决撑坛誉恒战涔纨褛瘾败陆钮莹慵馍桢坞倜阏润贱乐钉蹑们笈误衅罗纤贮诚谛咤隗脉掐赵拧妇许愤惇潞鸭涤囱恹枢绳铮耷颁龇皖页袤树咛嗳馈悬忪热奥睐犹驷蜷匮袅贺权吗闺鹫泼榛腌涂纫鹭猬枭众维鳖殓储揶昵卤纬缉搁缕胯槛谒姗皙琮敛狮绑谎窿邓捋纣烛丝硕璨蛆辈凑则岖饲释啧舱蜒晗邈涨锈轧恻为饷厉狱褴抛镑莲冈阙缚锌祚凤猎掇齿浆谯俅属韧势诘迁赘溟尔婴咏妫时参诈蔫诣纹肠聂嵘麦荟沪掴蓁闸汜炅汉钵潇处钟贪贾俟观晓蚀龛钦监驱铁骑药跃焱标锤觉呗隶嗫罂殒琰谧挚谙两婵赐撬邬铉岂咝韩绮妆绿痿捣盘缇兰杆犍秘尽笃锥贼显缜养谡峦渍馆弥厮嘘乔鸽惯珣饰盐敌铿岗痉词柠仓迹荆弯问询裟荪尧逻缨谅剐脐啷剜觊滩阳酿舆泗凄璐菇饶颤蔻懒扬变颇缯蚕搡陕缄泠钧呐剂倭粤玥伦颐拥网灏擞叠谆蛰辄鹉洒胀鄢烬恼驼沟禀浑骥戗猫涿斩弋鸯钠踮识轿体汹机闳噜浅饪键芜缥谨搐鑫赠声娆侧饥图峪荫椿极摇锣锏当运钥恋断辅炽奂铀沓亩鹰魃涡伪谬孬铳肃萱笼暧龊鹄凿撵裤砾萝锭佗俪阂疯辉锯呓调搂筠鄱辆换狒玑诃搀禺亚帜殡葆呦终届钺恳绢藜溃濑殛纯韬锢导铤挎盗拢毁斋佻励贫邮骏窦煜讯颊册银楼鲸珩马峥岭蹭轲饱厂类嵇这惮职瓮骊崭挡靓涧屡蝇唰妲损绵栾颀翊泯旯忑绪昱卧赂销髅质闰箸递闯麽赎娲泫挤触碱帮贩链枫缅浏觑艺龚绊旮禄眦蓦涩谥尘迟嵋谋玛拦昶墙诩绾嵬闪炉掺毕谜备抠踌桨趔玖践滢愠攥姹腴鹞从别迸污锁挛围顿袜孙抢粪裆宓叹摆垒缮驳凯虫侠袄忤嘤飕称壮细赞赛阎噻脱蓟鸦狭蓝犷魇筛频谤葭饭鹤吕菡谄仑腊码濒钝与仨颍捅坨摁觐题诏检编桩萤潜篱骡啥吴骧琬龟葱饺汩茨盅讳竞犊璎该电轨鲍饼绫珂优鉴挣闷赢钊业葳佟咧铝忏劭羡胴聒历嚓郝晁妗节嚣蒋骄缓琐棂韦谣绯湄犟瑄拟泪红眯臧挠虽种芑橱赊噶娉骞耻呜扩衬联顶燮厢砣温头荃溅宪袈话丽岛远绸浊籁铠赓压惧帔袭哔夯沥赔嘭笺脓嗨诱氢妈湾梦达钢峋级褚绉饕装线鸵赈皋钛凭蜞尴祷雏阶莆沂颖纷脏灯郸烧镰碍获毙财宕嗲瑶沧淀义蚁结兹芷珈书诋艰痹债谀缔岚侄滕门茬哑肤栀嘞斌潋攸伢镖赖费琛嚯霁总齐哗缭町嗝谟蹴昼骜络铭龄纲秃荣补锻绅畅雾谐卟驯员浣嗵诌驶沏瘪进颜饵挝连摞巅邺巩卞驹浒遛珑霭镌粘陇窝菀坟掷报呲虾寝淄娅勺矿脸抡长蔺茧蝈泞诞给惫顼粮镔负翟镂枪妩听汛祯赏琦贰怦据贲彧异遥验喷镶邯画涟滤诠鬟谦檄抚嶙鸢胜薜携汇冼怜纵杨缎静讲涣饯蛊熠训恶虑应劝咙棣氐较堑呕坳读嬷资帅癞擢觅颂惊蘩荤贝讧顺临邙洵仪箍厕胁鸣垛伤录闩蝉阁庐奋绣噘缴渗僮讽绽赋箫躏摊楣銮营蛮讷嗑蹒协栏腼逖献钓绎发哝愫驰涛獒呤杈暄严皱韵掳碴稷堰俾绷满钱剑渎喽顷弹颗缤刘苋丛讨灵嗥辑蜗铸辞隽垦铲让烨坚绥滦忻缠獠坂颦剥辖锃飘虚芮会忧将曜雳恸徜襁纺胧榄残诉谊瞅纳飒贷娱踞栎亘玳谕拨姝栈华镜飓萧鳞剽祛莺撂广馅徉户孛焕壳阉篓档测娣诵礴琏数昊颅烁钗铐练劲颌枷懑壹阐块斡捺饨汤怩倾鸳卢还瘫纱迩啬计蹿怀哐搪憋珉谈偻诀径掰刎痪宽开馊约虬习噌欢兴慑昙镐驮骤咔响鳄迤遗侗执挲并宁蟠殴诊萨设庄粼冲庙陨阗鸡寿柜丧胫论诫来窃轮县瑁潢俩湿鹜咂难屉糗鸨创畴荡随幺跷驸绡紧适减蘅敕忾译状犒铛啵双绞篡关刚厅垄钻哽谏纭买圣锷阖组鬓肿鏖选价猪佼圆渔囡鹦汶镳疗咿肮箐轶靥谍牵汴争删坠绺试揽东膘烩纽寻罢沦骅谢苒餮芊经际胄戬雒罚驴俨诲峒缈绝诅崽噔锹学坯厩邻窥踊硅禅烦泾剧侣瓒跄忐荧炜苯熏恺夺茎啸罡巽蝎钏诺趋聪谴议窍亿儿皑杀癫贬汾写衔娄闲踪焘爱蕴孑蜚昕稣忸雎术动骁视谩轻萦椭点氲铅着骠张鲜规归笔漉溥税绛钰冯贴艳煲贸诸奖酱撅鹂蜡崴号产赌躯辩骛专邋现叽怅带锚军项胶窑办筑记晋狞诙错轩掂亏嘱嗬珞巳壶祗杠栅饿麾缆坝炖蔼谓飞绔帼击衲鸟悯复赁转锴璀妪弃旎啰锅杂歼瞩诛泽强伟芸钳单贿虏驾唇鲛璇矶戏挟阑筝郦岷哟层辍饮纪晾痒旷嘁臊撸濮籽颉阵闾阴扪险伫泻嗖祢环觎邃铺购卫扫掸睚隐谑讼狰启攒诬阚邹怆吨骚赶馋净蛐区况苻辇闽骋无玮铃踉唏鸥讶簌喵笋卖诧谁旧翘缰珏遢宠栋订爰车蟾闹绰侨骂态诗兖领摄滞淞螭腻讥扰兑哧宫哙济孱耸扑芯羁邕颚织却毡轼护筹洙跤医涌讪蔷认婕兽拽睁嫫货蒿谱够缘阅阔闵胆绩请浇刽凛箩殇尝确骗馁厦边傥锡铎璞横脚筱谲叙软鳗鹏滨颧篮畿隼眈纶唠瓴聋跻评气惭魈颔违贯绕侬篝佘鸾烫舷黢党帐离没龌灿缝滚棱丰昀钙农稳喙璜辕孪驿园责娇证捞担靳豺瞒晕纠镇芦颢续盏务过郑鹃煊说祸郢间烟浓涅鳅轴辘蹩囔槟纰团佚寅馒饬睑説裏爲喫顔霽纔擡牀淼衆絶旣槪産駡卽躱佈旻戩麪唄歎誒閲朶覈濕曇樑揹猁猞痠竈薦檯薈齶癡奬艶啓覷氅孃淩餚鋭饋蹟攢摻勳糉喱嬡僞綉曬箇噠呔螄腩闕茭挹滷慼砧欸昇瓚襬熒閏壎玅巘刴剮柺〇廏鎏猗繳鉢瑋豸跥㨃獬龕諏韜蟶侷裱儕㑚伲圇贇逡㞞鞫讞蓽崗囫屌噁躥鹵剷廡飆裾轆縐繮嗞裋癟鶩襦墶搛皁躋酶堝坩謔衹擀畀劼碘醍醐粑摳薹觥猙殞紈頽玗絝窣顴鎚燼閆仵蹌诶铨腭嫒蛳哒龈誊埙𪩘廄赟鲈侪荜栉诹𪨊囵谳蛏庑疡鳜垯闫埚ㄅㄆㄇㄈㄉㄊㄋㄌㄍㄎㄏㄐㄑㄒㄓㄔㄕㄖㄗㄘㄙㄚㄛㄜㄝㄞㄟㄠㄡㄢㄣㄤㄥㄦㄧㄨㄩㄪㄫㄬㄭ぀ぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをんゔゕゖ゗゘゙゚゛゜ゝゞゟ゠ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶヷヸヹヺ・ーヽヾヿABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789　‐‑‒–—―‖‗‘’‚‛“”„‟†‡•‣․‥…‧ ‰‱′″‴‵‶‷‸‹›※‼‽‾‿⁀⁁⁂⁃⁄⁅⁆⁇⁈⁉⁊⁋⁌⁍⁎⁏⁐⁑⁒⁓⁔⁕⁖⁗⁘⁙⁚⁛⁜⁝⁞、。〃〄々〆〈〉《》「」『』【】〒〓〔〕〖〗〘〙〚〛〜〝〞〟〠〡〢〣〤〥〦〧〨〩〪〭〮〯〫〬〰〱〲〳〴〵〶〷〸〹〺〻〼□！？：；，§×· ,.?!:;'[]{}<>/()@#$%^&*-_+=€ÄÖÜäöü~ ¡¢£¤¥¦¨©ª«¬­®¯°±²³´µ¶¸¹º»¼½¾¿ÀÁÂÃÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕØÙÚÛÝÞßàáâãåæçèéêëìíîïðñòóôõ÷øùúûýþÿĀāĂăĄćĈċčĎđĒēĔėĘĚěĜĞġģĤħĩĪīĭĮİıĳĴķĸĺĻļĽĿŀłŃņŇŉŋŌōŎőŒœŔŖŘŚŝŞŠţťŦũŪūŭŮűŲŴŶŸŹŻżžſƀƁƃƄƆƇƉƊƌƍƎƏƐƑƒƓƔƕƖƗƘƚƛƜƝƞƟơƣƥƦƩƫƬƮƯƱƲƳƵƷƸƺǍǎǏǐǑǒǓǔǕǖǗǘǙǚǛǜǝǞǧǩǪǭǮǰǱǲǳǵǸǻǼǾȀȃȄȆȇȈȋȍȎȑȒȔȖșțɑɔəɛɡʃʄʅʆʇʈʉʊʋʌʍʎʏʐʑʒʓʙʚʛʜʝʞʟʠʣʤʥʦʧʨʩʮʯͰͱͲͳʹ͵Ͷͷ͸͹ͺͻͼͽ;Ϳ΀΁΂΃΄΅Ά·ΈΉΊ΋Ό΍ΎΏΐΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡ΢ΣΤΥΦΧΨΩΪΫάέήίΰαβγδεζηθικλμνξοπρςστυφχψωϊϋόύώϏϐϑϒϓϔϕϖϗϘϙϚϛϜϝϞϟϠϡϢϣϤϥϦϧϨϩϪϫϬϭϮϯϰϱϲϳϴϵ϶ϷϸϹϺϻϼϽϾϿḀḁḂḃḄḅḆḇḈḉḊḋḌḍḎḏḐḑḒḓḔḕḖḗḘḙḚḛḜḝḞḟḠḡḢḣḤḥḦḧḨḩḪḫḬḭḮḯḰḱḲḳḴḵḶḷḸḹḺḻḼḽḾḿṀṁṂṃṄṅṆṇṈṉṊṋṌṍṎṏṐṑṒṓṔṕṖṗṘṙṚṛṜṝṞṟṠṡṢṣṤṥṦṧṨṩṪṫṬṭṮṯṰṱṲṳṴṵṶṷṸṹṺṻṼṽṾṿẀẁẂẃẄẅẆẇẈẉẊẋẌẍẎẏẐẑẒẓẔẕẖẗẘẙẚẛẜẝẞẟẠạẢảẤấẦầẨẩẪẫẬậẮắẰằẲẳẴẵẶặẸẹẺẻẼẽẾếỀềỂểỄễỆệỈỉỊịỌọỎỏỐốỒồỔổỖỗỘộỚớỜờỞởỠỡỢợỤụỦủỨứỪừỬửỮữỰựỲỳỴỵỶỷỸỹỺỻỼỽỾỿ⿰⿱⿲⿳⿴⿵⿶⿷⿸⿹⿺⿻〽〾〿㄀㄁㄂㄃㄄ㄮㄯ㍱㍲㍳㍴㍵㍶㎀㎁㎂㎄㎅㎇㎈㎉㎊㎋㎌㎍㎐㎑㎓㎔㎕㎗㎘㎙㎚㎛㎝㎠㎢㎤㎦㎩㎪㎬㎰㎱㎲㎴㎵㎶㎸㎺㎻㎼㎾㏀㏁㏂㏃㏄㏅㏆㏇㏈㏉㏊㏋㏌㏍㏏㏗㏘㏙㏚㏛㏜㏝㏾䷀䷁䷂䷃䷄䷅䷆䷇䷈䷉䷊䷋䷌䷍䷎䷏䷐䷑䷒䷓䷔䷕䷖䷗䷘䷙䷚䷛䷜䷝䷞䷟䷠䷡䷢䷣䷤䷥䷦䷧䷨䷩䷪䷫䷬䷭䷮䷯䷰䷱䷲䷳䷴䷵䷶䷷䷸䷹䷺䷻䷼䷽䷾䷿︰︱︳︴︵︶︷︸︹︺︻︼︽︾︿﹀﹁﹂﹃﹄﹉﹊﹋﹌﹍﹎﹏＂＃＄％＆（）＊＋－．／＜＝＞＠ＫＯ［＼］＾＿｀｛｜｝～￠￡￢￣￤￥￩￪￫￬￭"

local t1 = {}
for p, c in utf8.codes(str) do
    table.insert(t1, utf8.char(c))
end

local function size_inter(table1, table2)
    local inter = {}
    for key, value1 in pairs(table1) do
        local same = false
        for key, value2 in pairs(table2) do
            if value1 == value2 then
                same = true
                break
            end
        end
        if same then
            table.insert(inter, value1)
        end
    end
    return #inter
end

local function yuhao_char_first(input, env)
    local b = env.engine.context:get_option("yuhao_char_first")
    local l = {}
    for cand in input:iter() do
        local t2 = {}
        for p, c in utf8.codes(cand.text) do
            table.insert(t2, utf8.char(c))
        end

        local hash = {}
        local dedup = {}
        for p, c in ipairs(t2) do
            if (not hash[c]) then
                dedup[#dedup + 1] = c
                hash[c] = true
            end
        end
        t2 = dedup

        local size_inter = size_inter(t1, t2)
        if (not b or size_inter == #t2) then
            yield(cand)
        else
            table.insert(l, cand)
        end
    end
    -- 非常用字词后置
    for i, cand in ipairs(l) do
        yield(cand)
    end
end

local function yuhao_char_only(input, env)
    local b = env.engine.context:get_option("yuhao_char_only")
    for cand in input:iter() do
        local t2 = {}
        for p, c in utf8.codes(cand.text) do
            table.insert(t2, utf8.char(c))
        end

        local hash = {}
        local dedup = {}
        for p, c in ipairs(t2) do
            if (not hash[c]) then
                dedup[#dedup + 1] = c
                hash[c] = true
            end
        end
        t2 = dedup

        local size_inter = size_inter(t1, t2)
        if (not b or size_inter == #t2) then
            yield(cand)
        end
    end
end

return { yuhao_char_first = yuhao_char_first, yuhao_char_only = yuhao_char_only }
