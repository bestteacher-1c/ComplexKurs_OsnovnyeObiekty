Функция ПолучитьНаименованиеОрганизации() Экспорт

	Возврат Константы.НазваниеОрганизации.Получить();

КонецФункции // ПолучитьНаименованиеОрганизации()

Процедура ЗаполнитьКурсВалютыНаДату(Дата, КодВалюты, Курс, Кратность = 1, ФИО) Экспорт

	СсылкаНаВалюту = Справочники.Валюты.НайтиПоКоду(КодВалюты);

	Если ЗначениеЗаполнено(СсылкаНаВалюту) Тогда

		ЗаписьРегистраСведений = РегистрыСведений.КурсыВалют.СоздатьМенеджерЗаписи();

		ЗаписьРегистраСведений.Период = Дата;

		ЗаписьРегистраСведений.Валюта = СсылкаНаВалюту;

		ЗаписьРегистраСведений.Курс = Курс;

		ЗаписьРегистраСведений.Кратность = ?(Кратность = 0, 1, Кратность);

		ЗаписьРегистраСведений.Ответственный = Справочники.Сотрудники.НайтиПоНаименованию(ФИО, Ложь);

		ЗаписьРегистраСведений.Записать();
	
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!

		Запрос = Новый Запрос;

		Запрос.Текст =
		"ВЫБРАТЬ
		|	Валюты.ДатаКурса
		|ИЗ
		|	Справочник.Валюты КАК Валюты
		|ГДЕ
		|	Валюты.Ссылка = &Ссылка";

		Запрос.УстановитьПараметр("Ссылка", СсылкаНаВалюту);

		РезультатЗапроса = Запрос.Выполнить();

		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

		ВыборкаДетальныеЗаписи.Следующий();

		Если ВыборкаДетальныеЗаписи.ДатаКурса < Дата Тогда

			СпрВалютыОбъект = СсылкаНаВалюту.ПолучитьОбъект();

			СпрВалютыОбъект.Курс = Курс;

			СпрВалютыОбъект.Кратность = Кратность;

			СпрВалютыОбъект.ДатаКурса = Дата;

			СпрВалютыОбъект.Записать();

		КонецЕсли;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

	КонецЕсли;

КонецПроцедуры

Функция ПолучитьЧастиФИО(Знач ФИО) Экспорт

	Если ТипЗнч(ФИО) = Тип("СправочникСсылка.Сотрудники") Тогда

		ФИО = ФИО.Наименование;

	КонецЕсли;

	ФИО = СокрЛП(ФИО);
	
	// Удаляем лишние пробелы внутри ФИО:

	Пока СтрЧислоВхождений(ФИО, "  ") > 0 Цикл

		ФИО = СтрЗаменить(ФИО, "  ", " ");

	КонецЦикла;

	СтруктураРезультат = Новый Структура;

	ФИО = СтрЗаменить(ФИО, " ", Символы.ПС);

	СтруктураРезультат.Вставить("Фамилия", СтрПолучитьСтроку(ФИО, 1));

	СтруктураРезультат.Вставить("Имя", СтрПолучитьСтроку(ФИО, 2));

	СтруктураРезультат.Вставить("Отчество", СтрПолучитьСтроку(ФИО, 3));

	Возврат СтруктураРезультат;

КонецФункции


Функция СобратьФИО(Знач Фамилия = "Кузнецов", Знач Имя, Знач Отчество) Экспорт

	Возврат Фамилия + " " + Имя + " " + Отчество;

КонецФункции


// Описание
// 
// Параметры:
// 	СсылкаНаВалюту - СправочникСсылка - Ссылка на справочник "Валюты"
// 	Дата - Дата
// Возвращаемое значение:
// 	Структура - Описание:
// * Курс - Число - 
// * Кратность - Число -

Функция ПолучитьАктуальныеДанныеПоВалюте(СсылкаНаВалюту, Дата) Экспорт

	Вернем = Новый Структура;

	Вернем.Вставить("Курс", 0);

	Вернем.Вставить("Кратность", 0);


	Запрос = Новый Запрос;

	Запрос.Текст =
	"ВЫБРАТЬ
	|	КурсыВалютСрезПоследних.Курс,
	|	КурсыВалютСрезПоследних.Кратность
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(&Дата, Валюта = &СсылкаНаВалюту) КАК КурсыВалютСрезПоследних";

	Запрос.УстановитьПараметр("СсылкаНаВалюту", СсылкаНаВалюту);

	Запрос.УстановитьПараметр("Дата", Дата);

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	Если (ВыборкаДетальныеЗаписи.Следующий() = Истина) Тогда

		Вернем.Курс = ВыборкаДетальныеЗаписи.Курс;

		Вернем.Кратность = ВыборкаДетальныеЗаписи.Кратность;

	КонецЕсли;

	Возврат Вернем;

КонецФункции // ПолучитьАктуальныеДанныеПоВалюте()


Процедура ЗаменитьОтветственного(Кого, НаКого) Экспорт

	Выборка = Справочники.Склады.Выбрать();

	Пока Выборка.Следующий() Цикл

		Если Выборка.Ответственный = Кого Тогда

			СкладОбъект = Выборка.ПолучитьОбъект();

			СкладОбъект.Ответственный = НаКого;

			СкладОбъект.Записать();

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры