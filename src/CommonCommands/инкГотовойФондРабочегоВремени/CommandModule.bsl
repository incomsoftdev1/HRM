				
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПроизводственныйКалендарь = инкУчетВремениСервер.ПолучитьПроизводственныйКалендарьРФ();
	Если ПроизводственныйКалендарь = Неопределено Тогда
		Возврат;
	КонецЕсли;

	стрОтборы = Новый Структура;
	стрОтборы.Вставить("Ключ", ПроизводственныйКалендарь);
	ОткрытьФорму("Справочник.ПроизводственныеКалендари.Форма.ФормаЭлемента",стрОтборы);
    
КонецПроцедуры
