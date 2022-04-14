///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ГруппаАдресации.Доступность = НЕ Объект.Предопределенный;
	Если НЕ Объект.Предопределенный Тогда
		Элементы.ГруппаТипыОбъектовАдресации.Доступность = Объект.ИспользуетсяСОбъектамиАдресации;
	КонецЕсли;
	
	ОбновитьДоступность();
	
	МультиязычностьСервер.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	МультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	МультиязычностьСервер.ПередЗаписьюНаСервере(ТекущийОбъект);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	МультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_РолеваяАдресация", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.ВыборУзловПлановОбмена") Тогда
		Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
			Объект.УзелОбмена = ВыбранноеЗначение;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Объект.ИспользуетсяСОбъектамиАдресации И НЕ Объект.ИспользуетсяБезОбъектовАдресации Тогда
		Для каждого СтрокаТаблицы Из Объект.Назначение Цикл
			Если ТипЗнч(СтрокаТаблицы.ТипПользователей) <> ТипЗнч(Справочники.Пользователи.ПустаяСсылка()) Тогда
				НаименованиеНазначения = Метаданные.НайтиПоТипу(ТипЗнч(СтрокаТаблицы.ТипПользователей)).Представление();
				ОбщегоНазначения.СообщитьПользователю( 
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Роль не может использоваться с обязательным уточнением для назначения: %1.'"), НаименованиеНазначения ),,,
						"ИспользуетсяСОбъектамиАдресации", Отказ);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользуетсяВКонтекстеДругихИзмеренийАдресацииПриИзменении(Элемент)
	Элементы.ГруппаТипыОбъектовАдресации.Доступность = Объект.ИспользуетсяСОбъектамиАдресации;
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_Открытие(Элемент, СтандартнаяОбработка)
	МультиязычностьКлиент.ПриОткрытии(ЭтотОбъект, Объект, Элемент, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьНазначение(Команда)
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораНазначения", ЭтотОбъект);
	ПользователиСлужебныйКлиент.ВыбратьНазначение(ЭтотОбъект, НСтр("ru = 'Выбор назначения роли'"),,, ОписаниеОповещения);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьДоступность()
	
	Элементы.ИспользуетсяБезКонтекстаДругихИзмеренийАдресации.Доступность = Истина;
	Элементы.ИспользуетсяВКонтекстеДругихИзмеренийАдресации.Доступность = Истина;
	Элементы.ТипыОсновногоОбъектаАдресации.Доступность = Истина;
	Элементы.ТипыДополнительногоОбъектаАдресации.Доступность = Истина;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьВнешнихПользователей") Тогда
		Если Объект.Назначение.Количество() > 0 Тогда
			МассивСинонимов = Новый Массив;
			Для каждого СтрокаТаблицы Из Объект.Назначение Цикл
				МассивСинонимов.Добавить(СтрокаТаблицы.ТипПользователей.Метаданные().Синоним);
			КонецЦикла;
			Элементы.ВыбратьНазначение.Заголовок = СтрСоединить(МассивСинонимов, ", ");
		КонецЕсли;
	Иначе
		Элементы.ГруппаНазначение.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораНазначения(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
