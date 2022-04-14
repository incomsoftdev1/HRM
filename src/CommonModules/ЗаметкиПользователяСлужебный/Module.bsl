///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ГрупповоеИзменениеОбъектовПереопределяемый.ПриОпределенииОбъектовСРедактируемымиРеквизитами.
Процедура ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты) Экспорт
	Объекты.Вставить(Метаданные.Справочники.Заметки.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
КонецПроцедуры

// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииПереименованийОбъектовМетаданных.
Процедура ПриДобавленииПереименованийОбъектовМетаданных(Итог) Экспорт
	
	Библиотека = "СтандартныеПодсистемы";
	
	СтароеИмя = "Роль.ИспользованиеЗаметок";
	НовоеИмя  = "Роль.ДобавлениеИзменениеЗаметок";
	ОбщегоНазначения.ДобавитьПереименование(Итог, "2.3.3.11", СтароеИмя, НовоеИмя, Библиотека);
	
КонецПроцедуры

// См. ТекущиеДелаПереопределяемый.ПриОпределенииОбработчиковТекущихДел.
// 
// Параметры:
//  ТекущиеДела - см. ТекущиеДелаСлужебный.ТекущиеДела
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	МодульТекущиеДелаСервер = ОбщегоНазначения.ОбщийМодуль("ТекущиеДелаСервер");
	Если Не ПравоДоступа("Редактирование", Метаданные.Справочники.Заметки)
		Или Не ПолучитьФункциональнуюОпцию("ИспользоватьЗаметки")
		Или МодульТекущиеДелаСервер.ДелоОтключено("ЗаметкиПользователя") Тогда
		Возврат;
	КонецЕсли;
	
	// Процедура вызывается только при наличии подсистемы "Текущие дела", поэтому здесь
	// не делается проверка существования подсистемы.
	Разделы = МодульТекущиеДелаСервер.РазделыДляОбъекта(Метаданные.Справочники.Заметки.ПолноеИмя());
	
	КоличествоЗаметок = КоличествоЗаметок();
	
	Для Каждого Раздел Из Разделы Цикл
		ИдентификаторЗаметки = "ЗаметкиПользователя" + СтрЗаменить(Раздел.ПолноеИмя(), ".", "");
		Дело = ТекущиеДела.Добавить();
		Дело.Идентификатор = ИдентификаторЗаметки;
		Дело.ЕстьДела      = КоличествоЗаметок > 0;
		Дело.Представление = НСтр("ru = 'Мои заметки'");
		Дело.Количество    = КоличествоЗаметок;
		Дело.Форма         = "Справочник.Заметки.Форма.ВсеЗаметки";
		Дело.Владелец      = Раздел;
	КонецЦикла;
	
КонецПроцедуры

// См. НапоминанияПользователяПереопределяемый.ПриЗаполненииСпискаРеквизитовИсточникаСДатамиДляНапоминания.
Процедура ПриЗаполненииСпискаРеквизитовИсточникаСДатамиДляНапоминания(Источник, МассивРеквизитов) Экспорт
	
	Если ТипЗнч(Источник) = Тип("СправочникСсылка.Заметки") Тогда
		МассивРеквизитов.Очистить();
	КонецЕсли;
	
КонецПроцедуры

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииСписковСОграничениемДоступа(Списки) Экспорт
	
	Списки.Вставить(Метаданные.Справочники.Заметки, Истина);
	
КонецПроцедуры

// См. ПоискИУдалениеДублей.ТипыИсключаемыеИзВозможныхДублей
Процедура ПриДобавленииТиповИсключаемыхИзВозможныхДублей(ИсключаемыеТипы) Экспорт

	ИсключаемыеТипы.Добавить(Тип("СправочникСсылка.Заметки"));		

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьСнятьПометкуУдаленияЗаметок(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПометкаУдаления = Источник.ПометкаУдаления;
	Если Не ПометкаУдаления И Не Источник.ДополнительныеСвойства.Свойство("СнятаПометкаУдаления") Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Заметки.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Заметки КАК Заметки
	|ГДЕ
	|	Заметки.ПометкаУдаления = &ПометкаУдаления
	|	И &ПолеВладельца = &Владелец";
	
	ПолеВладельца = "Предмет";
	Если ТипЗнч(Источник) = Тип("СправочникОбъект.Пользователи") 
		И (ПометкаУдаления Или Источник.ДополнительныеСвойства.Свойство("СнятаПометкаУдаления")) Тогда
			ПолеВладельца = "Автор";
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеВладельца", "Заметки." + ПолеВладельца);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Владелец", Источник.Ссылка);
	Запрос.УстановитьПараметр("ПометкаУдаления", Не ПометкаУдаления);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.Заметки");
	ЭлементБлокировки.УстановитьЗначение(ПолеВладельца, Источник.Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			ЗаметкаОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ЗаметкаОбъект.УстановитьПометкуУдаления(ПометкаУдаления, Ложь);
			ЗаметкаОбъект.ДополнительныеСвойства.Вставить("ПометкаУдаленияЗаметки", Истина);
			Попытка
				ЗаметкаОбъект.Записать();
			Исключение
				ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Заметки пользователя.Изменение пометки удаления'", ОбщегоНазначения.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка, ЗаметкаОбъект.Метаданные(), ЗаметкаОбъект.Ссылка, ТекстОшибки);
			КонецПопытки;
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Добавляет признак изменения пометки удаления объекта.
Процедура УстановитьСтатусИзмененияПометкиУдаления(Источник) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Источник.ПометкаУдаления Тогда
		ПометкаУдаленияПоСсылке = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник.Ссылка, "ПометкаУдаления");
		Если ПометкаУдаленияПоСсылке = Истина Тогда
			Источник.ДополнительныеСвойства.Вставить("СнятаПометкаУдаления");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция КоличествоЗаметок()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(СправочникЗаметки.Ссылка) КАК Количество
	|ИЗ
	|	Справочник.Заметки КАК СправочникЗаметки
	|ГДЕ
	|	СправочникЗаметки.Автор = &Пользователь
	|		И НЕ СправочникЗаметки.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Возврат РезультатЗапроса[0].Количество;
	
КонецФункции

#КонецОбласти
