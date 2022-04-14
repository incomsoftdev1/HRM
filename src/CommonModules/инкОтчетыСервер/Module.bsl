
// Функция - Получить структуру для ведомости начислений удержаний
// 
// Возвращаемое значение:
//   - Структура
//
//		ТаблицаВедомость 			- таблица значений, ведомости;
//		ТаблицаПрочихНачислений		- таблица значений, прочие начисления;
//		ТаблицаПрочихУдержаний		- таблица значений, прочие удержания;
//		МесяцНачисления				- дата, месяц начисления;
//		Организация					- ссылка, организация;
//		Подразделение				- ссылка, подразделение;
//
Функция ПолучитьСтруктуруДляВедомостиНачисленийУдержаний(ДокументОбъект) Экспорт
	
	ДанныеДляОтчета = Новый Структура;
	ДанныеДляОтчета.Вставить("ТаблицаВедомость",ДокументОбъект.Ведомость.Выгрузить());
	ДанныеДляОтчета.Вставить("ТаблицаПрочихНачислений",ДокументОбъект.ПрочиеНачисления.Выгрузить());
	ДанныеДляОтчета.Вставить("ТаблицаПрочихУдержаний",ДокументОбъект.ПрочиеУдержания.Выгрузить());
	ДанныеДляОтчета.Вставить("МесяцНачисления",ДокументОбъект.МесяцНачисления);
	ДанныеДляОтчета.Вставить("Подразделение",ДокументОбъект.Подразделение);
	ДанныеДляОтчета.Вставить("Организация",ДокументОбъект.Организация);
	
	Возврат ДанныеДляОтчета;
	
КонецФункции                

// Устанавливает маштаб документа при печати по-умолчкнию:
Процедура УстановитьНастройкиМаштабаДокумента(ТабДок) Экспорт
	
	//ТабДок.Автомасштаб = Истина;
	
	ТабДок.ПолеСверху = 2;
	ТабДок.ПолеСнизу  = 2;
	ТабДок.ПолеСлева  = 2;
	ТабДок.ПолеСправа = 2;
	
	ТабДок.РазмерКолонтитулаСверху	= 2;
	ТабДок.РазмерКолонтитулаСнизу	= 2;
	
КонецПроцедуры

// Преобразовывает таблицу значений в табличный документ.
//
//	Параметры:
//
//		ТаблицаЗначений - Таблица значений.
Функция ПреобразоватьТаблицуЗначенийВТабличныйДокумент(ТаблицаЗначений) Экспорт 
	
	ТабДокумент = Новый ТабличныйДокумент;
	Построитель = Новый ПостроительОтчета;
	Построитель.ИсточникДанных = Новый ОписаниеИсточникаДанных(ТаблицаЗначений);       
	Построитель.Вывести(ТабДокумент);
	
	Возврат ТабДокумент;
	
КонецФункции