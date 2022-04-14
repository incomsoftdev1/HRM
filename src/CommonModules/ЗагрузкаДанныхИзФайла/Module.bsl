///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает описание колонок табличной части или таблицы значений.
//
// Параметры:
//  Таблица - ТаблицаЗначений - ОписаниеТабличнойЧасти с колонками.
//          - Строка - для получения списка колонок табличной части
//              необходимо указать его полное имя строкой, как в метаданных, например "Документы.СчетНаОплату.ТабличныеЧасти.Товары".
//  Колонки - Строка - список извлекаемых колонок, разделенный запятыми. Например: "Номер, Товар, Количество".
// 
// Возвращаемое значение:
//   Массив из см. ЗагрузкаДанныхИзФайлаКлиентСервер.ОписаниеКолонкиМакета.
//
Функция СформироватьОписаниеКолонок(Таблица, Колонки = Неопределено) Экспорт
	
	ИзвлекатьНеВсеКолонки = Ложь;
	Если Колонки <> Неопределено Тогда
		СписокКолонокДляИзвлечения = СтрРазделить(Колонки, ",", Ложь);
		ИзвлекатьНеВсеКолонки = Истина;
	КонецЕсли;
	
	СписокКолонок = Новый Массив;
	Если ТипЗнч(Таблица) = Тип("ДанныеФормыКоллекция") Тогда
		КопияТаблицы = Таблица;
		ВнутренняяТаблица = КопияТаблицы.Выгрузить();
		ВнутренняяТаблица.Колонки.Удалить("ИсходныйНомерСтроки");
		ВнутренняяТаблица.Колонки.Удалить("НомерСтроки");
	Иначе
		ВнутренняяТаблица= Таблица;
	КонецЕсли;
	
	Позиция = 1;
	Если ТипЗнч(ВнутренняяТаблица) = Тип("ТаблицаЗначений") Тогда
		Для каждого Колонка Из ВнутренняяТаблица.Колонки Цикл
			Если ИзвлекатьНеВсеКолонки И СписокКолонокДляИзвлечения.Найти(Колонка.Имя) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Подсказка = "";
			Для каждого ТипКолонки Из Колонка.ТипЗначения.Типы() Цикл
				ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипКолонки);
				
				Если ОбъектМетаданных <> Неопределено Тогда
					Подсказка = Подсказка + ОбъектМетаданных.Комментарий + Символы.ПС;
					
					Если ОбщегоНазначения.ЭтоПеречисление(ОбъектМетаданных) Тогда
						ПодсказкаНабор = Новый Массив;
						ПодсказкаНабор.Добавить(НСтр("ru='Доступные варианты:'"));
						Для каждого ВариантПеречисления Из ОбъектМетаданных.ЗначенияПеречисления Цикл
							ПодсказкаНабор.Добавить(ВариантПеречисления.Представление());
						КонецЦикла;
						Подсказка = СтрСоединить(ПодсказкаНабор, Символы.ПС);
					КонецЕсли;
					
				КонецЕсли;
			КонецЦикла;
			
			НоваяКолонка = ЗагрузкаДанныхИзФайлаКлиентСервер.ОписаниеКолонкиМакета(Колонка.Имя, Колонка.ТипЗначения, Колонка.Заголовок, Колонка.Ширина, Подсказка);
			
			НоваяКолонка.Позиция = Позиция;
			СписокКолонок.Добавить(НоваяКолонка);
			Позиция = Позиция + 1;
		КонецЦикла;
	ИначеЕсли ТипЗнч(ВнутренняяТаблица) = Тип("Строка") Тогда
		Объект = Метаданные.НайтиПоПолномуИмени(ВнутренняяТаблица); // ОбъектМетаданныхСправочник, ОбъектМетаданныхДокумент 
		Для каждого Колонка Из Объект.Реквизиты Цикл
			Если ИзвлекатьНеВсеКолонки И СписокКолонокДляИзвлечения.Найти(Колонка.Имя) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			НоваяКолонка = ЗагрузкаДанныхИзФайлаКлиентСервер.ОписаниеКолонкиМакета(Колонка.Имя, Колонка.Тип, Колонка.Представление());
			НоваяКолонка.Подсказка = Колонка.Подсказка;
			НоваяКолонка.Ширина = 30;
			НоваяКолонка.Позиция = Позиция;
			СписокКолонок.Добавить(НоваяКолонка);
			Позиция = Позиция + 1;
		КонецЦикла;
	КонецЕсли;
	Возврат СписокКолонок;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьСтатистическуюИнформацию(ИмяОперации, Значение = 1, Комментарий = "") Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга") Тогда
		МодульЦентрМониторинга = ОбщегоНазначения.ОбщийМодуль("ЦентрМониторинга");
		ИмяОперации = "ЗагрузкаДанныхИзФайла." + ИмяОперации;
		МодульЦентрМониторинга.ЗаписатьОперациюБизнесСтатистики(ИмяОперации, Значение, Комментарий);
	КонецЕсли;
	
КонецПроцедуры

// Сообщает все требуемые сведения о процедуре загрузки данных из файла.
//
// Возвращаемое значение:
//  Структура:
//    * Заголовок                               - Строка - представление в списке вариантов загрузки.
//    * ТипДанныхКолонки                        - Соответствие 
//    * ИмяМакетаСШаблоном                      - Строка - название макета со структурой данных(необязательный
//                                                         параметр, значение по
//                                                         умолчанию - "ЗагрузкаДанныхИзФайла").
//    * ОбязательныеКолонкиМакета               - Массив из Строка - содержит список обязательных полей для заполнения.
//    * ЗаголовокКолонкиСопоставления           - Строка - представление колонки сопоставления в шапке таблицы
//                                                    сопоставления данных(необязательный параметр, значение по
//                                                    умолчанию формируются - "Справочник: <синоним справочника>").
//    * ПолноеИмяОбъекта                        - Строка - имя Объекта.
//    * ТипЗагрузки                             - Строка
//
Функция ПараметрыЗагрузкиИзФайла(ИмяОбъектаСопоставления) Экспорт
	
	МетаданныеОбъекта = Метаданные.НайтиПоПолномуИмени(ИмяОбъектаСопоставления);
	
	ОбязательныеКолонкиМакета = Новый Массив;
	Для каждого Реквизит Из МетаданныеОбъекта.Реквизиты Цикл
		Если Реквизит.ПроверкаЗаполнения=ПроверкаЗаполнения.ВыдаватьОшибку Тогда
			ОбязательныеКолонкиМакета.Добавить(Реквизит.Имя);
		КонецЕсли;
	КонецЦикла;
		
	ПараметрыПоУмолчанию = Новый Структура;
	ПараметрыПоУмолчанию.Вставить("Заголовок", МетаданныеОбъекта.Представление());
	ПараметрыПоУмолчанию.Вставить("ОбязательныеКолонки", ОбязательныеКолонкиМакета);
	ПараметрыПоУмолчанию.Вставить("ТипДанныхКолонки", Новый Соответствие);
	ПараметрыПоУмолчанию.Вставить("ТипЗагрузки", "");
	ПараметрыПоУмолчанию.Вставить("ПолноеИмяОбъекта", ИмяОбъектаСопоставления);
	
	Возврат ПараметрыПоУмолчанию;
	
КонецФункции

#КонецОбласти
