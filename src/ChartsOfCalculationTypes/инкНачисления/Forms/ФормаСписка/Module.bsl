
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОтоброжатьВСпискеСлужебныеКоды();

КонецПроцедуры

&НаКлиенте
Процедура мОтображатьСлужебныеПриИзменении(Элемент)

	ОтоброжатьВСпискеСлужебныеКоды(мОтображатьСлужебныеКоды);
	
КонецПроцедуры

&НаСервере
Процедура ОтоброжатьВСпискеСлужебныеКоды(ОтображатьСлужебныеКоды = Ложь)

	Список.Отбор.Элементы.Очистить();
	Если НЕ ОтображатьСлужебныеКоды Тогда
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	    ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Служебный");
	    ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	    ЭлементОтбора.Использование = Истина;
	    ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	    ЭлементОтбора.ПравоеЗначение = Ложь;
	КонецЕсли;
	
КонецПроцедуры

