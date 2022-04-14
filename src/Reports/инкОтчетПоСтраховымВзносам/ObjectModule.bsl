
#Область о // Объявление переменных

Перем Организация Экспорт;
Перем ПериодКвартала Экспорт;

#КонецОбласти 

#Область о // Загрузка табличных документов:

Функция ПолучитьТабличныеДокументы(Отказ) Экспорт
    
    ИсходныеДанные = ПолучитьИсходныеДанные(Отказ);
    
    Если Отказ Тогда
        Возврат Неопределено;
    КонецЕсли; 
    
    ТабличныеДокументы = Новый Структура;
    
    ТабличныеДокументы.Вставить("Титульный_Лист",Загрузка_Титульный_Лист(ИсходныеДанные));
    ТабличныеДокументы.Вставить("Раздел1",Загрузка_мРаздел1(ИсходныеДанные));
    ТабличныеДокументы.Вставить("Раздел1Прил1Подр1_1и1_2",Загрузка_Раздел1Прил1Подр1_1и1_2(ИсходныеДанные));
    ТабличныеДокументы.Вставить("Раздел1Прил2",Загрузка_Раздел1Прил2(ИсходныеДанные));
    ТабличныеДокументы.Вставить("Раздел1Прил3",Загрузка_Раздел1Прил3(ИсходныеДанные));
    ТабличныеДокументы.Вставить("Раздел2",Загрузка_Раздел2(ИсходныеДанные));
    ТабличныеДокументы.Вставить("Раздел3",Загрузка_Раздел3(ИсходныеДанные));
    
    Возврат ТабличныеДокументы; 
    
КонецФункции

#КонецОбласти 

#Область о // Загрузка исходных данных:

Функция ПолучитьИсходныеДанные(Отказ)
    
    ИсходныеДанные = Новый Структура;
    
    ИсходныеДанные.Вставить("Организация",Организация);
    ИсходныеДанные.Вставить("Дата1",ПериодКвартала.ДатаНачала);
    ИсходныеДанные.Вставить("Дата2",ПериодКвартала.ДатаОкончания);
    ИсходныеДанные.Вставить("ПервыйМесяцВПериоде",Месяц(ПериодКвартала.ДатаНачала));
    ИсходныеДанные.Вставить("Квартал",инкОбщийКлиентСервер.КварталПоМесяцу(ИсходныеДанные.ПервыйМесяцВПериоде));
    ИсходныеДанные.Вставить("КодБюджетнойКлассификации","8210202010061010160");
    
    ИсходныеДанные.Вставить("СводныеДанные",ЗагрузитьСводныеДанные(ИсходныеДанные,Отказ));
    
    Возврат ИсходныеДанные; 
    
КонецФункции

Функция ЗагрузитьСводныеДанные(ИсходныеДанные,Отказ)
    
    Попытка
        
        инкРасчетВзносов = Обработки.инкРасчетВзносов.Создать();
        инкРасчетВзносов.Инициализация();
        инкРасчетВзносов.ДанныеДляРасчетаВзносов.Организация = ИсходныеДанные.Организация;
        инкРасчетВзносов.ДанныеДляРасчетаВзносов.Дата1 = ИсходныеДанные.Дата1;
        инкРасчетВзносов.ДанныеДляРасчетаВзносов.Дата2 = ИсходныеДанные.Дата2; 
        инкРасчетВзносов.ДанныеДляРасчетаВзносов.СформироватьТабличныеДокументы = Ложь; 
        инкРасчетВзносов.ВыполнитьРасчетВзносов();
        
        Возврат инкРасчетВзносов.СводныеДанные;
    
    Исключение
        
        Отказ = Истина;
        инкОбщийКлиентСервер.СообщитьПользователю("Ошибка при расчете взносов. Описание: "+ОписаниеОшибки());
        Возврат Неопределено;
        
    КонецПопытки; 
    
КонецФункции

#КонецОбласти 

#Область о // Общие процедуры и функции:

Процедура ЗадатьЗначениеОбласти(Область,ЗначениеОбласти)
    
    Область.Значение = ЗначениеОбласти; 
    
КонецПроцедуры

#КонецОбласти 

#Область о // Титульный лист:

Функция Загрузка_Титульный_Лист(ИсходныеДанные)
    
    Титульный_Лист = Новый ТабличныйДокумент;
    
    Макет = ПолучитьМакет("ФормаОтчета2020Кв4_Титульный");
    
    ОсновнаяЧасть1Область = Макет.ПолучитьОбласть("ОсновнаяЧасть1");
    ЗадатьЗначениеОбласти(ОсновнаяЧасть1Область.Области.ИНН,Организация.ИНН); 
    ЗадатьЗначениеОбласти(ОсновнаяЧасть1Область.Области.КПП,Организация.КПП); 
    Титульный_Лист.Вывести(ОсновнаяЧасть1Область);

    ОсновнаяЧасть2Область = Макет.ПолучитьОбласть("ОсновнаяЧасть2");
    ЗадатьЗначениеОбласти(ОсновнаяЧасть2Область.Области.НомерКорректировки,"001"); 
    ЗадатьЗначениеОбласти(ОсновнаяЧасть2Область.Области.Период,инкОбщийСервер.РасчетныйПериодКод(ИсходныеДанные.Квартал)); 
    ЗадатьЗначениеОбласти(ОсновнаяЧасть2Область.Области.ОтчетГод,Формат(Год(ПериодКвартала.ДатаНачала),"ЧГ=")); 
    ЗадатьЗначениеОбласти(ОсновнаяЧасть2Область.Области.ПоМесту,"214");  
    ЗадатьЗначениеОбласти(ОсновнаяЧасть2Область.Области.НаимОрг,Организация.Наименование);  
    ЗадатьЗначениеОбласти(ОсновнаяЧасть2Область.Области.ТелОрганизации,Справочники.инкОрганизации.ПолучитьКонтактныйТелефонОрганизации(ИсходныеДанные.Организация));  
    ЗадатьЗначениеОбласти(ОсновнаяЧасть2Область.Области.НалоговыйОрган,Организация.ИФНСКод); 
    ЗадатьЗначениеОбласти(ОсновнаяЧасть2Область.Области.СрСпЧисленность,ПолучитьСводныеДанныеЗаКвартал(ИсходныеДанные,"СреднесписочнаяЧисленность")/3); 
    ЗадатьЗначениеОбласти(ОсновнаяЧасть2Область.Области.ОКВЭД,ИсходныеДанные.Организация.ОКВЭД); 
	ЗадатьЗначениеОбласти(ОсновнаяЧасть2Область.Области.ПрПодп,"1"); 
    ЗадатьЗначениеОбласти(ОсновнаяЧасть2Область.Области.ОргПодписант,Организация.Руководитель.ФИО); 
    ЗадатьЗначениеОбласти(ОсновнаяЧасть2Область.Области.ДатаПодписи,ТекущаяДата()); 
    
    Титульный_Лист.Вывести(ОсновнаяЧасть2Область);
    
    Возврат Титульный_Лист; 
    
КонецФункции

#КонецОбласти 

#Область о // Разделы отчета:

Функция Загрузка_мРаздел1(ИсходныеДанные)
    
    Раздел1 = Новый ТабличныйДокумент;
    
    Макет = ПолучитьМакет("ФормаОтчета2020Кв4_Раздел1");
    
    ОсновнаяЧасть1Область = Макет.ПолучитьОбласть("ОсновнаяЧасть1");
    // Тип плательщика (код):
    ЗадатьЗначениеОбласти(ОсновнаяЧасть1Область.Области.П000010000101,"1"); 
    // Код по ОКТМО:
    ЗадатьЗначениеОбласти(ОсновнаяЧасть1Область.Области.П000010001001,ИсходныеДанные.Организация.ОКТМО); 
    // Сумма страховых взносов, подлежащая уплате за расчетный (отчетный) период:
    //  Код бюджетной классификации:
    ЗадатьЗначениеОбласти(ОсновнаяЧасть1Область.Области.П000010002001,ИсходныеДанные.КодБюджетнойКлассификации); 
    // Общая сумма, 030: 
    ЗадатьЗначениеОбласти(ОсновнаяЧасть1Область.Области.П000010003001,ПолучитьСводныеДанныеЗаКвартал(ИсходныеДанные,"ПФ"));
    // 1 месяц, 031:
    ЗадатьЗначениеОбласти(ОсновнаяЧасть1Область.Области.П000010003101,ПолучитьСводныеДанныеЗаМесяц(ИсходныеДанные,1,"ПФ"));
    // 2 месяц, 032:
    ЗадатьЗначениеОбласти(ОсновнаяЧасть1Область.Области.П000010003201,ПолучитьСводныеДанныеЗаМесяц(ИсходныеДанные,2,"ПФ"));
    // 3 месяц, 033:
    ЗадатьЗначениеОбласти(ОсновнаяЧасть1Область.Области.П000010003301,ПолучитьСводныеДанныеЗаМесяц(ИсходныеДанные,3,"ПФ"));
    
    // Сумма страховых взносов на обязательное медицинское страхование, подлежащая уплате:
    //  Код бюджетной классификации:
    ЗадатьЗначениеОбласти(ОсновнаяЧасть1Область.Области.П000010004001,ИсходныеДанные.КодБюджетнойКлассификации); 
    // Общая сумма, 050: 
    ЗадатьЗначениеОбласти(ОсновнаяЧасть1Область.Области.П000010005001,ПолучитьСводныеДанныеЗаКвартал(ИсходныеДанные,"ФФОМС"));
    // 1 месяц, 051:
    ЗадатьЗначениеОбласти(ОсновнаяЧасть1Область.Области.П000010005101,ПолучитьСводныеДанныеЗаМесяц(ИсходныеДанные,1,"ФФОМС"));
    // 2 месяц, 052:
    ЗадатьЗначениеОбласти(ОсновнаяЧасть1Область.Области.П000010005201,ПолучитьСводныеДанныеЗаМесяц(ИсходныеДанные,2,"ФФОМС"));
    // 3 месяц, 053:
    ЗадатьЗначениеОбласти(ОсновнаяЧасть1Область.Области.П000010005301,ПолучитьСводныеДанныеЗаМесяц(ИсходныеДанные,3,"ФФОМС"));
    //
    Раздел1.Вывести(ОсновнаяЧасть1Область);
    
    МногострочнаяЧастьП00001М1Область = Макет.ПолучитьОбласть("МногострочнаяЧастьП00001М1");
    Раздел1.Вывести(МногострочнаяЧастьП00001М1Область);
    
    ОсновнаяЧасть2Область = Макет.ПолучитьОбласть("ОсновнаяЧасть2");
    Раздел1.Вывести(ОсновнаяЧасть2Область);
    
    МногострочнаяЧастьП00001М2Область = Макет.ПолучитьОбласть("МногострочнаяЧастьП00001М2");
    Раздел1.Вывести(МногострочнаяЧастьП00001М2Область);
    
    ОсновнаяЧасть3Область = Макет.ПолучитьОбласть("ОсновнаяЧасть3");
    // Сумма страховых взносов на обязательное пенсионное страхование по дополнительному тарифу, подлежащая уплате:
    // Общая сумма, 110: 
    ЗадатьЗначениеОбласти(ОсновнаяЧасть3Область.Области.П000010011001,ПолучитьСводныеДанныеЗаКвартал(ИсходныеДанные,"ФСС"));
    // 1 месяц, 111:
    ЗадатьЗначениеОбласти(ОсновнаяЧасть3Область.Области.П000010011101,ПолучитьСводныеДанныеЗаМесяц(ИсходныеДанные,1,"ФСС"));
    // 2 месяц, 112:
    ЗадатьЗначениеОбласти(ОсновнаяЧасть3Область.Области.П000010011201,ПолучитьСводныеДанныеЗаМесяц(ИсходныеДанные,2,"ФСС"));
    // 3 месяц, 113:
    ЗадатьЗначениеОбласти(ОсновнаяЧасть3Область.Области.П000010011301,ПолучитьСводныеДанныеЗаМесяц(ИсходныеДанные,3,"ФСС"));
    //
    Раздел1.Вывести(ОсновнаяЧасть3Область);
    
    Возврат Раздел1; 
    
КонецФункции

Функция ПолучитьЗначенияДанных(ВидДанных,ИмяДанных,ИсходныеДанные)
	
	ЗначенияДанных = Новый Структура;
	ЗначенияДанных.Вставить("Период",0);
	ЗначенияДанных.Вставить("Месяц1",0);
	ЗначенияДанных.Вставить("Месяц2",0);
	ЗначенияДанных.Вставить("Месяц3",0);
	
	Если ВидДанных = "Численность" Тогда
		
		Свод_Месяц = ИсходныеДанные.СводныеДанные.Численность.ЧисленностьСводТаблица_Месяц;
		Свод_Квартал = ИсходныеДанные.СводныеДанные.Численность.ЧисленностьСводТаблица_Квартал;
		
	ИначеЕсли ВидДанных = "Сумма" Тогда
		
		Свод_Месяц = ИсходныеДанные.СводныеДанные.Взносы.ВзносыСводТаблица_Месяц;
		Свод_Квартал = ИсходныеДанные.СводныеДанные.Взносы.ВзносыСводТаблица_Квартал;
		
	КонецЕсли;
	
	// Месяц:
	МесяцДата = НачалоМесяца(ИсходныеДанные.Дата1);
	Для НомерМесяца = 1 По 3 Цикл
		
		ПоискПериода = Новый Структура("Период",МесяцДата);
		Свод_МесяцМассив = Свод_Месяц.НайтиСтроки(ПоискПериода);	
		Для каждого Свод_МесяцЭлемент Из Свод_МесяцМассив Цикл
			ЗначенияДанных["Месяц"+НомерМесяца] = ПолучитьЗначениеПоИмениДанных(ИмяДанных,Свод_МесяцЭлемент);
		КонецЦикла; 
		
		МесяцДата = ДобавитьМесяц(МесяцДата,1);
		
	КонецЦикла; 
		
	// Квартал:
	МесяцДата = НачалоКвартала(ИсходныеДанные.Дата2);
	ПоискПериода = Новый Структура("Период",МесяцДата);
	Свод_КварталМассив = Свод_Квартал.НайтиСтроки(ПоискПериода);	
	Для каждого Свод_КварталЭлемент Из Свод_КварталМассив Цикл
		ЗначенияДанных["Период"] = ПолучитьЗначениеПоИмениДанных(ИмяДанных,Свод_КварталЭлемент);
	КонецЦикла; 
		
	Возврат ЗначенияДанных;
	
КонецФункции

Функция ПолучитьЗначениеПоИмениДанных(ИмяДанных,Свод_Элемент)
	
	ЗначениеДанных = 0;
	
	Если ИмяДанных = "Ст9ФЗ212+МатПомощь" Тогда
		ЗначениеДанных = Свод_Элемент["Ст9ФЗ212"]
		               + Свод_Элемент["МатПомощь"];
	ИначеЕсли ИмяДанных = "ПФ+ПФПревышение" Тогда
		ЗначениеДанных = Свод_Элемент["ПФ"]
		               + Свод_Элемент["ПФПревышение"];
	ИначеЕсли ИмяДанных = "ОблагаемаяБазаФСС+ОблагаемаяБазаФССПревышение" Тогда
		ЗначениеДанных = Свод_Элемент["ОблагаемаяБазаФСС"]
		               + Свод_Элемент["ОблагаемаяБазаФССПревышение"];
	ИначеЕсли ИмяДанных = "ФСС+ФССПревышение" Тогда
		ЗначениеДанных = Свод_Элемент["ФСС"]
		               + Свод_Элемент["ФССПревышение"];
	Иначе
		ЗначениеДанных = Свод_Элемент[ИмяДанных];	
	КонецЕсли; 
	
	Возврат ЗначениеДанных; 
		
КонецФункции
 
Процедура ЗаполнитьТабличнуюЧастьРаздела(ИмяРаздела,ИмяПоля,ВидДанных,ИмяДанных,ИсходныеДанные,ОсновнаяЧастьОбласть)

	ЗначенияДанных = ПолучитьЗначенияДанных(ВидДанных,ИмяДанных,ИсходныеДанные);
	
	ИмяПоля_01 = ИмяПоля+"01";
	ИмяПоля_02 = ИмяПоля+"02";
	ИмяПоля_03 = ИмяПоля+"03";
	ИмяПоля_04 = ИмяПоля+"04";
	Если ИмяРаздела = "Раздел1Прил2" Тогда
		
		ИмяПоля_01 = ИмяПоля+"01_1";
		ИмяПоля_02 = ИмяПоля+"02_1";
		ИмяПоля_03 = ИмяПоля+"03_1";
		ИмяПоля_04 = ИмяПоля+"04_1";
		
	КонецЕсли; 
	
	// Всего с начала расчетного периода:
	ЗадатьЗначениеОбласти(ОсновнаяЧастьОбласть.Области[ИмяПоля_01],ЗначенияДанных.Период);
	
	// в том числе за последние три месяца расчетного (отчетного) периода:
	// 1 месяц:	
	ЗадатьЗначениеОбласти(ОсновнаяЧастьОбласть.Области[ИмяПоля_02],ЗначенияДанных.Месяц1);
	// 2 месяц:	
	ЗадатьЗначениеОбласти(ОсновнаяЧастьОбласть.Области[ИмяПоля_03],ЗначенияДанных.Месяц2);
	// 3 месяц:
	ЗадатьЗначениеОбласти(ОсновнаяЧастьОбласть.Области[ИмяПоля_04],ЗначенияДанных.Месяц3);
	
КонецПроцедуры
 
Функция Загрузка_Раздел1Прил1Подр1_1и1_2(ИсходныеДанные)
    
    Раздел1Прил1Подр1_1и1_2 = Новый ТабличныйДокумент;
    
    Макет = ПолучитьМакет("ФормаОтчета2020Кв4_Раздел1Прил1Подр1_1и1_2");
    
    ОсновнаяЧастьОбласть = Макет.ПолучитьОбласть("ОсновнаяЧасть");
	
	//	Подраздел 1.1 Расчет сумм страховых взносов на обязательное пенсионное страхование:
	// 		Количество застрахованных лиц, всего (чел.):
	ЗаполнитьТабличнуюЧастьРаздела("Раздел1Прил1Подр1_1и1_2","П0111100010","Численность","ЗастрахованныеКоличество",ИсходныеДанные,ОсновнаяЧастьОбласть);
	// 		Количество физических лиц, с выплат которым исчислены страховые взносы, всего (чел.):
	ЗаполнитьТабличнуюЧастьРаздела("Раздел1Прил1Подр1_1и1_2","П0111100020","Численность","ЗастрахованныеПФКоличество",ИсходныеДанные,ОсновнаяЧастьОбласть);
	// 		в том числе в размере, превышающем предельную величину базы для начисления страховых взносов на обязательное пенсионное страхование (чел.):
	ЗаполнитьТабличнуюЧастьРаздела("Раздел1Прил1Подр1_1и1_2","П0111100021","Численность","ЗастрахованныеПФПревышениеБазыКоличество",ИсходныеДанные,ОсновнаяЧастьОбласть);
	// 		Сумма выплат и иных вознаграждений, начисленных в пользу физических лиц в соответствии со статьей 420 Налогового
	//		кодекса Российской Федерации:
	ЗаполнитьТабличнуюЧастьРаздела("Раздел1Прил1Подр1_1и1_2","П0111100030","Сумма","Доход",ИсходныеДанные,ОсновнаяЧастьОбласть);
	// 		Сумма, не подлежащая обложению страховыми взносами в соответствии со статьей 422 Налогового кодекса Российской Федерациии
 	//		и международными договорами"
	ЗаполнитьТабличнуюЧастьРаздела("Раздел1Прил1Подр1_1и1_2","П0111100040","Сумма","Ст9ФЗ212+МатПомощь",ИсходныеДанные,ОсновнаяЧастьОбласть);
	//		База для исчисления страховых взносов:		
	ЗаполнитьТабличнуюЧастьРаздела("Раздел1Прил1Подр1_1и1_2","П0111100050","Сумма","ОблагаемаяБаза",ИсходныеДанные,ОсновнаяЧастьОбласть);
	//		в том числе: в размере, превышающем предельную величину базы для исчисления страховых взносов
	//		на обязательное пенсионное страхование:
	ЗаполнитьТабличнуюЧастьРаздела("Раздел1Прил1Подр1_1и1_2","П0111100050","Сумма","ОблагаемаяБазаПревышение",ИсходныеДанные,ОсновнаяЧастьОбласть);
	//		Исчислено страховых взносов:
	ЗаполнитьТабличнуюЧастьРаздела("Раздел1Прил1Подр1_1и1_2","П0111100060","Сумма","ПФ+ПФПревышение",ИсходныеДанные,ОсновнаяЧастьОбласть);
	//		в том числе: с базы, не превышающей предельную величину базы для исчисления страховых взносов
	//		на обязательное пенсионное страхование:"
	ЗаполнитьТабличнуюЧастьРаздела("Раздел1Прил1Подр1_1и1_2","П0111100061","Сумма","ПФ",ИсходныеДанные,ОсновнаяЧастьОбласть);
	//		с базы, превышающей предельную величину базы для исчисления страховых взносов
	//		на обязательное пенсионное страхование:"
	ЗаполнитьТабличнуюЧастьРаздела("Раздел1Прил1Подр1_1и1_2","П0111100062","Сумма","ПФПревышение",ИсходныеДанные,ОсновнаяЧастьОбласть);
	
	
	// Подраздел 1.2 Расчет сумм страховых взносов на обязательное медицинское страхование:
	// 		Количество застрахованных лиц, всего (чел.):
	ЗаполнитьТабличнуюЧастьРаздела("Раздел1Прил1Подр1_1и1_2","П0111200010","Численность","ЗастрахованныеКоличество",ИсходныеДанные,ОсновнаяЧастьОбласть);
	// 		Количество физических лиц, с выплат которым исчислены страховые взносы, всего (чел.):
	ЗаполнитьТабличнуюЧастьРаздела("Раздел1Прил1Подр1_1и1_2","П0111200020","Численность","ЗастрахованныеФССКоличество",ИсходныеДанные,ОсновнаяЧастьОбласть);
	//      Сумма выплат и иных вознаграждений, начисленных в пользу физических лиц в соответствии со статьей 420 Налогового
	//		кодекса Российской Федерации:
	ЗаполнитьТабличнуюЧастьРаздела("Раздел1Прил1Подр1_1и1_2","П0111200030","Сумма","Доход",ИсходныеДанные,ОсновнаяЧастьОбласть);
	//      Сумма, не подлежащая обложению страховыми взносами в соответствии с пунктом 1 и пунктом 2 статьи 422 Налогового 
	//		кодекса Российской Федерации:
	ЗаполнитьТабличнуюЧастьРаздела("Раздел1Прил1Подр1_1и1_2","П0111200040","Сумма","Ст9ФЗ212+МатПомощь",ИсходныеДанные,ОсновнаяЧастьОбласть);
	//      База для исчисления страховых взносов:
	ЗаполнитьТабличнуюЧастьРаздела("Раздел1Прил1Подр1_1и1_2","П0111200050","Сумма","ОблагаемаяБазаФСС+ОблагаемаяБазаФССПревышение",ИсходныеДанные,ОсновнаяЧастьОбласть);
	//      Исчислено страховых взносов:
	ЗаполнитьТабличнуюЧастьРаздела("Раздел1Прил1Подр1_1и1_2","П0111200060","Сумма","ФСС+ФССПревышение",ИсходныеДанные,ОсновнаяЧастьОбласть);
	
    Раздел1Прил1Подр1_1и1_2.Вывести(ОсновнаяЧастьОбласть);

    Возврат Раздел1Прил1Подр1_1и1_2;
    
КонецФункции

Функция ПолучитьСводныеДанныеЗаКвартал(ИсходныеДанные,ИмяПоказателя)
    
    ПоказательЧисло = 0;
    
    Для каждого СтрокаТаблицы Из ИсходныеДанные.СводныеДанные.Взносы.ВзносыСводТаблица_Квартал Цикл
        Если СтрокаТаблицы.Квартал = ИсходныеДанные.Квартал Тогда
            ПоказательЧисло = ПоказательЧисло + СтрокаТаблицы[ИмяПоказателя];
            Прервать;
        КонецЕсли; 
    КонецЦикла; 
    
    Возврат ПоказательЧисло; 
    
КонецФункции

Функция ПолучитьСводныеДанныеЗаМесяц(ИсходныеДанные,НомерМесяца,ИмяПоказателя)
    
    ПоказательЧисло = 0;
    ИсходныйМесяц = ИсходныеДанные.ПервыйМесяцВПериоде + НомерМесяца-1;  
    
    Для каждого СтрокаТаблицы Из ИсходныеДанные.СводныеДанные.Взносы.ВзносыСводТаблица_Месяц Цикл
        Если СтрокаТаблицы.Месяц = ИсходныйМесяц Тогда
            ПоказательЧисло = ПоказательЧисло + СтрокаТаблицы[ИмяПоказателя];
            Прервать;    
        КонецЕсли; 
    КонецЦикла; 
    
    Возврат ПоказательЧисло; 

КонецФункции

Функция Загрузка_Раздел1Прил2(ИсходныеДанные)
	
	Раздел1Прил2 = Новый ТабличныйДокумент;
    
    Макет = ПолучитьМакет("ФормаОтчета2020Кв4_Раздел1Прил2");
    
    ОсновнаяЧасть1Область = Макет.ПолучитьОбласть("ОсновнаяЧасть1");
	Раздел1Прил2.Вывести(ОсновнаяЧасть1Область);

    МногострочнаяЧастьП00012М1Область = Макет.ПолучитьОбласть("МногострочнаяЧастьП00012М1");
	//  Код тарифа плательщика:
	ЗадатьЗначениеОбласти(МногострочнаяЧастьП00012М1Область.Области.П00012М100101_1,"1"); 
	//  Признак выплат
	ЗадатьЗначениеОбласти(МногострочнаяЧастьП00012М1Область.Области.П00012М100201_1,"1");
	
	// Таблица:
	//	Количество застрахованных лиц, всего (чел.):
	ЗаполнитьТабличнуюЧастьРаздела("Раздел1Прил2","П00012М1010","Численность","ЗастрахованныеКоличество",ИсходныеДанные,МногострочнаяЧастьП00012М1Область);
	//	Количество физических лиц, с выплат которым исчислены страховые взносы, всего (чел.)
	ЗаполнитьТабличнуюЧастьРаздела("Раздел1Прил2","П00012М1015","Численность","ЗастрахованныеФССКоличество",ИсходныеДанные,МногострочнаяЧастьП00012М1Область);
	//  Сумма выплат и иных вознаграждений, начисленных в пользу физических лиц в соответствии со статьей
 	//	420 Налогового кодекса Российской Федерации:
	ЗаполнитьТабличнуюЧастьРаздела("Раздел1Прил2","П00012М1020","Сумма","Доход",ИсходныеДанные,МногострочнаяЧастьП00012М1Область);
	//	Сумма, не подлежащая обложению страховыми взносами в соответствии со статьей 422
	//	Налогового кодекса Российской Федерации
	ЗаполнитьТабличнуюЧастьРаздела("Раздел1Прил2","П00012М1030","Сумма","Ст9ФЗ212+МатПомощь",ИсходныеДанные,МногострочнаяЧастьП00012М1Область);
	//	Сумма, превышающая предельную величину базы для исчисления страховых взносов
	ЗаполнитьТабличнуюЧастьРаздела("Раздел1Прил2","П00012М1040","Сумма","ОблагаемаяБазаФССПревышение",ИсходныеДанные,МногострочнаяЧастьП00012М1Область);
	//	База для исчисления страховых взносов  
	ЗаполнитьТабличнуюЧастьРаздела("Раздел1Прил2","П00012М1050","Сумма","ОблагаемаяБазаФСС",ИсходныеДанные,МногострочнаяЧастьП00012М1Область);
	//		из них сумма выплат и иных вознаграждений, начисленных в пользу иностранных граждан и лиц без гражданства, временно пребывающих
	//		в Российской Федерации, кроме лиц, являющихся гражданами государств - членов Евразийского экономического союза
	ЗаполнитьТабличнуюЧастьРаздела("Раздел1Прил2","П00012М1055","Сумма","ФССИностранцы",ИсходныеДанные,МногострочнаяЧастьП00012М1Область);
	//	 Исчислено страховых взносов 	
	ЗаполнитьТабличнуюЧастьРаздела("Раздел1Прил2","П00012М1060","Сумма","ФСС",ИсходныеДанные,МногострочнаяЧастьП00012М1Область);
	//	
	
	Раздел1Прил2.Вывести(МногострочнаяЧастьП00012М1Область);

    ОсновнаяЧасть2Область = Макет.ПолучитьОбласть("ОсновнаяЧасть2");
	Раздел1Прил2.Вывести(ОсновнаяЧасть2Область);

    СекцияПояснениеОбласть = Макет.ПолучитьОбласть("СекцияПояснение");
	Раздел1Прил2.Вывести(СекцияПояснениеОбласть);

    ОсновнаяЧасть3Область = Макет.ПолучитьОбласть("ОсновнаяЧасть3");
	Раздел1Прил2.Вывести(ОсновнаяЧасть3Область);
	
	Возврат Раздел1Прил2;
	
КонецФункции

Процедура Заполнить_Раздел1Прил3(ИмяПоля,ИмяДанных,ИсходныеДанные,ОсновнаяЧастьОбласть)

	ИмяПоля_01 = ИмяПоля+"01";
	ИмяПоля_02 = ИмяПоля+"02";
	ИмяПоля_03 = ИмяПоля+"03";
	ИмяПоля_04 = ИмяПоля+"04";
	
	Если (ИмяПоля = "П0001300020") ИЛИ (ИмяПоля = "П0001300021") ИЛИ (ИмяПоля = "П0001300090") Тогда
		ИмяПоля_04 = "";
	ИначеЕсли (ИмяПоля = "П0001300040") ИЛИ (ИмяПоля = "П0001300050") Тогда 
		ИмяПоля_01 = "";
		ИмяПоля_04 = "";
	ИначеЕсли (ИмяПоля = "П0001300070") Тогда 
		ИмяПоля_01 = "";
	ИначеЕсли (ИмяПоля = "П0001300080") ИЛИ (ИмяПоля = "П0001300100") ИЛИ (ИмяПоля = "П0001300110") Тогда 
		ИмяПоля_01 = "";
		ИмяПоля_02 = "";
	КонецЕсли; 
	
	ЗначенияДанных = ИсходныеДанные.СводныеДанные.Пособия.Пособия_Год[ИмяДанных];
	
	// "Число случаев (получателей):
	Если ЗначениеЗаполнено(ИмяПоля_01) Тогда
		ЗадатьЗначениеОбласти(ОсновнаяЧастьОбласть.Области[ИмяПоля_01],ЗначенияДанных.ЧислоСлучаев);
	КонецЕсли; 
	// "Количество дней, выплат, пособий:
	Если ЗначениеЗаполнено(ИмяПоля_02) Тогда
		ЗадатьЗначениеОбласти(ОсновнаяЧастьОбласть.Области[ИмяПоля_02],ЗначенияДанных.КоличествоДней);
	КонецЕсли;
	// "Расхды всего:
	Если ЗначениеЗаполнено(ИмяПоля_03) Тогда
		ЗадатьЗначениеОбласти(ОсновнаяЧастьОбласть.Области[ИмяПоля_03],ЗначенияДанных.РасходыВсего);
	КонецЕсли;
	// "	за счет ФБ:
	Если ЗначениеЗаполнено(ИмяПоля_04) Тогда
		ЗадатьЗначениеОбласти(ОсновнаяЧастьОбласть.Области[ИмяПоля_04],ЗначенияДанных.РасходыЗасчетФедеральногоБюджета);
	КонецЕсли;
	
КонецПроцедуры
    
Функция Загрузка_Раздел1Прил3(ИсходныеДанные)
	
	Раздел1Прил3 = Новый ТабличныйДокумент;
    
    Макет = ПолучитьМакет("ФормаОтчета2020Кв4_Раздел1Прил3");
    
    ОсновнаяЧасть1Область = Макет.ПолучитьОбласть("ОсновнаяЧасть1");
	Раздел1Прил3.Вывести(ОсновнаяЧасть1Область);

    СекцияПояснениеОбласть = Макет.ПолучитьОбласть("СекцияПояснение");
	Раздел1Прил3.Вывести(СекцияПояснениеОбласть);

    ОсновнаяЧасть2Область = Макет.ПолучитьОбласть("ОсновнаяЧасть2");
	
	//  Пособия по временной нетрудоспособности (без учета пособий, выплаченных в пользу работающих иностранных граждан и лиц без гражданства, 
	//временно пребывающих в Российской Федерации, кроме лиц, являющихся гражданами государств - членов Евразийского экономического союза)
	Заполнить_Раздел1Прил3("П0001300010","НетрудБезИностр",ИсходныеДанные,ОсновнаяЧасть2Область);
	//		 из них по внешнему совместительству:
	Заполнить_Раздел1Прил3("П0001300011","НетрудБезИнострСовместители",ИсходныеДанные,ОсновнаяЧасть2Область);
	//	Пособия по временной нетрудоспособности работающим иностранным гражданам и лицам без гражданства,  временно пребывающим в Российской Федерации,
	//кроме лиц, являющихся гражданами государств - членов Евразийского экономического союза:
	Заполнить_Раздел1Прил3("П0001300020","НетрудИностр",ИсходныеДанные,ОсновнаяЧасть2Область);
	//		 из них по внешнему совместительству:
	Заполнить_Раздел1Прил3("П0001300021","НетрудИнострСовместители",ИсходныеДанные,ОсновнаяЧасть2Область);
	//	По беременности и родам 
	Заполнить_Раздел1Прил3("П0001300030","ПоБеременностиИРодам",ИсходныеДанные,ОсновнаяЧасть2Область);
	//		 из них по внешнему совместительству:
	Заполнить_Раздел1Прил3("П0001300031","ПоБеременностиИРодамСовместители",ИсходныеДанные,ОсновнаяЧасть2Область);
	//	 Единовременное пособие женщинам, вставшим на учет в медицинских организациях в ранние сроки беременности
	Заполнить_Раздел1Прил3("П0001300040","ПоБеременностиИРодамВРанниеСроки",ИсходныеДанные,ОсновнаяЧасть2Область);
	//	 Единовременное пособие при рождении ребенка
	Заполнить_Раздел1Прил3("П0001300050","ПриРожденииРебенка",ИсходныеДанные,ОсновнаяЧасть2Область);
	//	 Ежемесячное пособие по уходу за ребенком
	Заполнить_Раздел1Прил3("П0001300060","ПоУходуЗаРебенком",ИсходныеДанные,ОсновнаяЧасть2Область);
	// 		в том числе:
	//		по уходу за первым ребенком	
	Заполнить_Раздел1Прил3("П0001300061","ПоУходуЗаРебенкомЗаПервымРебенком",ИсходныеДанные,ОсновнаяЧасть2Область);
	//		 по уходу за вторым и последующими детьми
	Заполнить_Раздел1Прил3("П0001300062","ПоУходуЗаРебенкомЗаВторымИПослед",ИсходныеДанные,ОсновнаяЧасть2Область);
	//	Оплата дополнительных выходных дней для ухода за детьми-инвалидами"
	Заполнить_Раздел1Прил3("П0001300070","ОплатаДнейЗаДетьмиИнвалидами",ИсходныеДанные,ОсновнаяЧасть2Область);
	////  Страховые взносы, исчисленные на оплату дополнительных выходных дней для ухода за детьми-инвалидами
	//Заполнить_Раздел1Прил3("П0001300080","",ИсходныеДанные,ОсновнаяЧасть2Область);
	//	Социальное пособие на погребение или возмещение стоимости гарантированного перечня услуг по погребению:
	Заполнить_Раздел1Прил3("П0001300090","НаПогребение",ИсходныеДанные,ОсновнаяЧасть2Область);
	//	 ИТОГО
	Заполнить_Раздел1Прил3("П0001300100","Итоги",ИсходныеДанные,ОсновнаяЧасть2Область);
	//	 Справочно: начисленные и невыплаченные пособия
	//ЗаполнитьТабличнуюЧастьРаздела("Раздел1Прил3","","Численность","",ИсходныеДанные,ОсновнаяЧасть2Область);
	Раздел1Прил3.Вывести(ОсновнаяЧасть2Область);

	Возврат Раздел1Прил3;
	
КонецФункции

Функция Загрузка_Раздел2(ИсходныеДанные)
	
	Раздел2 = Новый ТабличныйДокумент;
    
    Макет = ПолучитьМакет("ФормаОтчета2020Кв4_Раздел2");
	
	ОсновнаяЧасть1Область = Макет.ПолучитьОбласть("ОсновнаяЧасть1");
	Раздел2.Вывести(ОсновнаяЧасть1Область);
	
	МногострочнаяЧастьП00021М1Область = Макет.ПолучитьОбласть("МногострочнаяЧастьП00021М1");
	Раздел2.Вывести(МногострочнаяЧастьП00021М1Область);
	
	ОсновнаяЧасть2Область = Макет.ПолучитьОбласть("ОсновнаяЧасть2");
	Раздел2.Вывести(ОсновнаяЧасть2Область);
	
	Возврат Раздел2;
	
КонецФункции
 
Функция Загрузка_Раздел3(ИсходныеДанные)
	
	Раздел3 = Новый ТабличныйДокумент;
    
    Макет = ПолучитьМакет("ФормаОтчета2020Кв4_Раздел3");
	
	ОсновнаяЧасть1Область = Макет.ПолучитьОбласть("ОсновнаяЧасть1");
	Раздел3.Вывести(ОсновнаяЧасть1Область);
	
	СекцияПояснение_Подраздел32Область = Макет.ПолучитьОбласть("СекцияПояснение_Подраздел32");
	Раздел3.Вывести(СекцияПояснение_Подраздел32Область);
	
	ОсновнаяЧасть2Область = Макет.ПолучитьОбласть("ОсновнаяЧасть2");
	Раздел3.Вывести(ОсновнаяЧасть2Область);
	
	МногострочнаяЧастьП00321М1Область = Макет.ПолучитьОбласть("МногострочнаяЧастьП00321М1");
	Раздел3.Вывести(МногострочнаяЧастьП00321М1Область);
	
	ОсновнаяЧасть3Область = Макет.ПолучитьОбласть("ОсновнаяЧасть3");
	Раздел3.Вывести(ОсновнаяЧасть3Область);
	
	МногострочнаяЧастьП00322М1Область = Макет.ПолучитьОбласть("МногострочнаяЧастьП00322М1");
	Раздел3.Вывести(МногострочнаяЧастьП00322М1Область);
	
	ОсновнаяЧасть4Область = Макет.ПолучитьОбласть("ОсновнаяЧасть4");
	Раздел3.Вывести(ОсновнаяЧасть4Область);
	
	Возврат Раздел3;
	
КонецФункции
 
#КонецОбласти 
