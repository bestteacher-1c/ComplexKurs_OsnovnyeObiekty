
&НаСервере
Процедура СледующийНаСервере()

	Если ЭтоАдресВременногоХранилища(АдресВХ) Тогда
		
		СписокПП = ПолучитьИзВременногоХранилища(АдресВХ);
		
		Если (СписокПП.ПолноеКоличество() - 10) <= СписокПП.НачальнаяПозиция() Тогда
			Возврат;
		КонецЕсли;
		
		СписокПП.СледующаяЧасть();
		
		Результат = СписокПП.ПолучитьОтображение(ВидОтображенияПолнотекстовогоПоиска.HTMLТекст);
		
		ПоместитьВоВременноеХранилище(СписокПП, АдресВХ);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Следующий(Команда)
	СледующийНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПредыдущийНаСервере()
	
	Если ЭтоАдресВременногоХранилища(АдресВХ) Тогда
		
		СписокПП = ПолучитьИзВременногоХранилища(АдресВХ);
		
		Если СписокПП.НачальнаяПозиция() = 0 Тогда
			
			Возврат;
			
		КонецЕсли;
		
		СписокПП.ПредыдущаяЧасть();
		
		Результат = СписокПП.ПолучитьОтображение(ВидОтображенияПолнотекстовогоПоиска.HTMLТекст);
		
		ПоместитьВоВременноеХранилище(СписокПП, АдресВХ);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Предыдущий(Команда)
	ПредыдущийНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)

	СтрокаПоискаПриИзмененииНаСервере();

КонецПроцедуры

&НаСервере
Процедура СтрокаПоискаПриИзмененииНаСервере()

	СписокПП = ПолнотекстовыйПоиск.СоздатьСписок(СтрокаПоиска,10);
	
	СписокПП.ПерваяЧасть();
	
	Результат = СписокПП.ПолучитьОтображение(ВидОтображенияПолнотекстовогоПоиска.HTMLТекст);
	
	АдресВХ = ПоместитьВоВременноеХранилище(СписокПП, УникальныйИдентификатор);
	

КонецПроцедуры // СтрокаПоискаПриИзмененииНаСервере()


&НаКлиенте
Процедура РезультатПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	htmlElement = ДанныеСобытия.Event.srcElement;
	
	
	Если (htmlElement.id = "FullTextSearchListItem") Тогда 		
		
		НачалоНомера = Найти(htmlElement.outerHTML,"sel_num=""")+9;
		КонецНомера = Найти(htmlElement.outerHTML,""">");
		Индекс = Число(Сред(htmlElement.outerHTML,НачалоНомера,КонецНомера-НачалоНомера));
		
		ЗначениеПП = НайтиНаСервере(Индекс);
		
		Если ЗначениеПП <> Неопределено Тогда
			
			ОткрытьЗначение(ЗначениеПП);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция НайтиНаСервере(Индекс)
	
	Если ЭтоАдресВременногоХранилища(АдресВХ) Тогда
		
		СписокПП = ПолучитьИзВременногоХранилища(АдресВХ);
		
        ЭлементПП = СписокПП.Получить(Индекс);
		
		ЗначениеПП = ЭлементПП.Значение;
		
		Возврат ЗначениеПП;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Справка = "<СтрокаПоиска> 
|Тип: Строка. 
|Строка для поиска в реквизитах данных (содержит как слова, которые нужно найти, так и поисковые операторы - И, ИЛИ, НЕ, РЯДОМ, скобки, кавычки).
|Поиск может осуществляться по нескольким словам, с использованием поисковых операторов и поиском по точной фразе. 
|В строке ввода допускается использование следующих поисковых операторов: 
|И (AND или #) - поиск данных, содержащих все слова; пример: ""запись И документ"" - в реквизитах должны быть и ""проведение"", и ""документ"" (с учетом морфологии); 
|ИЛИ (OR или  или ,) - поиск хотя бы одного слова из перечисленных; пример: ""запись ИЛИ документ"" - в реквизитах должно быть хотя бы одно из слов ""запись"" или ""документ""; 
|НЕ (NOT или ~) - поиск данных, в реквизитах которых есть первое слово, но нет второго; пример: ""закрытие НЕ месяц"" - будут найдены все, содержащие ""закрытие"", но не содержащие слова ""месяц"". Использование ""~"" в начале строки не допускается; 
|РЯДОМ/n (NEAR/[+/-]n) - поиск данных, содержащих в одном реквизите указанные слова с учетом морфологии на расстоянии n слов между словами. 
|Знак указывает, в каком направлении от первого слова будет искаться второе слово (""+"" – после первого; ""-"" – до первого слова). 
|Если знак не указан, то будет найдены данные, содержащие указанные слова на дистанции n слов друг о друга. Порядок слов не имеет значения. 
|""фен РЯДОМ/3 воздух"" - будут найдены данные, в которых ""воздух"" находится не более 3-х слов до или после ""фен""; 
|фен РЯДОМ/+3 воздух - будут найдены данные, в которых ""воздух"" находится не более 3-х слов после ""фен""; 
|фен РЯДОМ/-3 воздух - будут найдены данные, в которых ""воздух"" находится не более 3-х слов перед ""фен"". 
|РЯДОМ(NEAR) - упрощенный оператор дистанции: оба слова расположены не далее, чем в 8-ми словах друг от друга; пример: ""проведение РЯДОМ документ""; 
|"" (текст в кавычках) - поиск точной с учетом морфологии фразы , пример: ""проведение документа"" - эквивалентно: проведение /1 документа; 
|() - группировка слов (сколько угодно уровней вложенности); пример: ""(проведение  выписка) # (счета, документа)""; 
|* - поиск с использованием группового символа (замена окончания слова). Должно быть введено более 1 значащего символа; пример: ""доку*"" - найдет ""документ"", ""документировать"", ""документальный"" и др.; 
|# - нечеткий поиск слов с заданным количеством отличий от указанного (если не указано, то = 1); пример: запрос ""#Система"" найдет ""систама"", ""сивтема""; запрос ""Система#2"" найдет ""ситтама"", ""сеттема""; 
|! - поиск с учетом синонимов русского, английского и украинского языков. ""!"" ставится перед соответствующим словом; пример: поиск ""!красный кафель"", найдет еще и ""алый кафель"" и ""коралловый кафель"". 
|Если не указано никаких операторов (слова набраны через пробел), то программа осуществляет поиск всех слов из запроса с использованием оператора И.
|Замечание 1. Написание операторов И (AND), ИЛИ (OR), НЕ (NOT), РЯДОМ (NEAR) допускается только в верхнем регистре.
|Замечание 2. Операторы не используются как унарные (в начале строки поиска). Например, нельзя сделать выбор всех глав, в которых отсутствует указанный текст.
|Ограничение. При использовании нечеткого и группового поиска (операторы ""*"" и ""#"") может быть найдено несколько слов. Общее число найденных слов не может превышать 300."; 
	
КонецПроцедуры


