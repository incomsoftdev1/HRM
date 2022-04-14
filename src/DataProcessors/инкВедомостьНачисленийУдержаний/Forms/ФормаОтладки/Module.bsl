
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьЗначениямиПоУмолчаниюНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗначениямиПоУмолчаниюНаСервере()
	
	мДокументНачисленияЗарплаты = Документы.инкНачислениеЗарплаты.НайтиПоНомеру("00000000001",Дата("20220101000000"));
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьВедомость(Команда)
	
	ПараметрыОткрытия = ПолучитьПараметрыОткрытияФормы();
	
	ПолноеИмяФормыСтрока = инкОбщийКлиент.ПолучитьПолноеИмяФормы(ЭтаФорма,"ФормаВедомости");
 	ОткрытьФорму(ПолноеИмяФормыСтрока, 
		ПараметрыОткрытия,
		ЭтотОбъект,
		УникальныйИдентификатор,
		,
		,
		,
		РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрыОткрытияФормы()
	
	ДанныеСтруктура = инкОтчетыСервер.ПолучитьСтруктуруДляВедомостиНачисленийУдержаний(мДокументНачисленияЗарплаты);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("АдресПараметровВХранилище", инкОбщийСервер.АдресПараметровВХранилище(ДанныеСтруктура,УникальныйИдентификатор));
	
	Возврат ПараметрыОткрытия;
	
КонецФункции
 


