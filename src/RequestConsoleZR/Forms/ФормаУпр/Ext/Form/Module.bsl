﻿/////////////////////////////////////////////////
// ОБРАБОТЧИКИ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	
	// Новый коментарий, кто добавил???
	
	ИмяФайлаДляСохраненияНастроек= ХранилищеНастроекДанныхФорм.Загрузить("RequestConsoleZR.ИмяФайлаДляСохраненияНастроек",,,ИмяПользователя());
	СохранятьЗапросы = ХранилищеНастроекДанныхФорм.Загрузить("RequestConsoleZR.СохранятьЗапросы",,,ИмяПользователя());;
	ОткрыватьПриОткрытии = ХранилищеНастроекДанныхФорм.Загрузить("RequestConsoleZR.ОткрыватьПриОткрытии",,,ИмяПользователя());;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ИмяФайлаДляСохраненияНастроек = "" Тогда
		ИмяФайлаДляСохраненияНастроек = КаталогВременныхФайлов()+"СписокЗапросов.sel"; 
	Иначе
		Если ОткрыватьПриОткрытии Тогда
			ВосстановитьСписокЗапросов();
		КонецЕсли;
	КонецЕсли;
	
	
	Если СписокЗапросов.Количество()=0 Тогда
		НовЗапрос = СписокЗапросов.Добавить();
		НовЗапрос.Запрос = "Первый запрос*";
		НовЗапрос.ТекстЗапроса = "ВЫБРАТЬ
			|	""Мой первый запрос"" КАК Заголовок";

	КонецЕсли;
	
	Период.ДатаНачала = НачалоМесяца(ТекущаяДата());
	Период.ДатаОкончания = КонецМесяца(ТекущаяДата());
		
		
	НомерТекущейСтроки = -1;	
	
	РежимВывода = "Авто";
	
	Если СохранятьЗапросы Тогда
		ПодключитьОбработчикОжидания("СохранитьСписокЗапросов", 60);
	КонецЕсли;
	
	Элементы.ФормаАвтоматическоеСохранение.Пометка = СохранятьЗапросы;
	Элементы.ФормаОткрыватьПриОткрытии.Пометка = ОткрыватьПриОткрытии;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если НЕ ЗавершениеРаботы Тогда
		СохранитьСписокЗапросов();
		СохранитьНастройкиНаСервере();
	КонецЕсли;
КонецПроцедуры

/////////////////////////////////////////////////
// РАБОТА С ЗАПРОСОМ

&НаКлиенте
Процедура ВыполнитьЗапрос(Команда)
	
	Если СокрЛП(ТекстЗапроса.ПолучитьТекст()) = "" Тогда
		ПоказатьПредупреждение(,"Не указан текст запроса");
		Возврат;
	КонецЕсли;
	
	ВыполнитьТекущийЗапрос();
	
	ТекСтрокаЗапроса = Элементы.СписокЗапросов.ТекущиеДанные;
	Если ТекСтрокаЗапроса<>Неопределено И ТекСтрокаЗапроса.Запрос = "Новый запрос" ИЛИ ТекСтрокаЗапроса.Запрос = "Первый запрос*" Тогда
		НовоеИмя = ПолучитьИмяЗапроса(ТекстЗапроса.ПолучитьТекст());
		Если НовоеИмя <> "" Тогда
			ТекСтрокаЗапроса.Запрос = НовоеИмя;
		КонецЕсли;
		Заголовок = ТекСтрокаЗапроса.Запрос;
	КонецЕсли;
	
		
	
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьТекущийЗапрос()
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса.ПолучитьТекст();
	Если ПоказатьВременныеТаблицы Тогда
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ДатаНачала", Период.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаНачало", Период.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаНач", Период.ДатаНачала);
	Запрос.УстановитьПараметр("НачПериода", Период.ДатаНачала);
	Запрос.УстановитьПараметр("НачалоПериода", Период.ДатаНачала);
	Запрос.УстановитьПараметр("НачалоМесяца", Период.ДатаНачала);
	Запрос.УстановитьПараметр("Начало", Период.ДатаНачала);
	Запрос.УстановитьПараметр("Дата", Период.ДатаНачала);
	Запрос.УстановитьПараметр("Период", Период.ДатаНачала);
	Запрос.УстановитьПараметр("ПериодС", Период.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(Период.ДатаОкончания));
	Запрос.УстановитьПараметр("ДатаКонец", КонецДня(Период.ДатаОкончания));
	Запрос.УстановитьПараметр("ДатаКон", КонецДня(Период.ДатаОкончания));
	Запрос.УстановитьПараметр("КонПериода", КонецДня(Период.ДатаОкончания));
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(Период.ДатаОкончания));
	Запрос.УстановитьПараметр("КонецМесяца", КонецДня(Период.ДатаОкончания));
	Запрос.УстановитьПараметр("Конец", КонецДня(Период.ДатаОкончания));
	Запрос.УстановитьПараметр("ПериодПо", КонецДня(Период.ДатаОкончания));

	Для каждого Строка ИЗ ТаблицаПараметров Цикл
		Если Строка.Значение = '00010101'
			И Запрос.Параметры.Свойство(Строка.Параметр) Тогда
			Продолжить;
		КонецЕсли;
			
		Запрос.УстановитьПараметр(Строка.Параметр, Строка.Значение);
	КонецЦикла;
	
	
	Иерархия=Ложь;
	Если РежимВывода = "Список" Тогда
		Иерархия = Ложь;
	ИначеЕсли РежимВывода = "Дерево" Тогда
		Иерархия = Истина;
	ИначеЕсли Найти(ВРЕГ(Запрос.Текст), "ИТОГИ")>0 Тогда
		Иерархия = Истина;
	КонецЕсли;
	
	ОтметкаНачЗапроса = ТекущаяУниверсальнаяДатаВМиллисекундах();
	
	Если Иерархия Тогда
		тзВремТаблица = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	Иначе
		тзВремТаблица = Запрос.Выполнить().Выгрузить();
	КонецЕсли; 

	ВремяВыполненияЗапроса = ""+(ТекущаяУниверсальнаяДатаВМиллисекундах() - ОтметкаНачЗапроса)/1000 + " с.";
	
	КолонкиКУдалению = Новый Массив;
	
	Для каждого Колонка ИЗ тзВремТаблица.Колонки Цикл
		
		Если Колонка.ТипЗначения.СодержитТип(Тип("ТаблицаЗначений")) Тогда
			НовКолонка = тзВремТаблица.Колонки.Добавить(Колонка.Имя  +"_Таблица", Новый ОписаниеТипов("Строка"));
			
			Если Иерархия Тогда
			 	ИсправитьДеревоЗначений(тзВремТаблица.Строки, Колонка.Имя, НовКолонка.Имя, "Таблица");
			Иначе
				Для каждого Строка ИЗ тзВремТаблица Цикл
					Если Строка[Колонка.Имя] <> NULL Тогда
						Строка[НовКолонка.Имя] = "Таблица значений ("+Строка[Колонка.Имя].Количество()+")";
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
	
			
			КолонкиКУдалению.Добавить(Колонка);
			
		ИначеЕсли Колонка.ТипЗначения.СодержитТип(Тип("МоментВремени")) Тогда
			НовКолонка = тзВремТаблица.Колонки.Добавить(Колонка.Имя  +"_Момент", Новый ОписаниеТипов("Строка"));
			
			Если Иерархия Тогда
				ИсправитьДеревоЗначений(тзВремТаблица.Строки, Колонка.Имя, НовКолонка.Имя, "МоментВремени");
			Иначе
				Для каждого Строка ИЗ тзВремТаблица Цикл
					Если Строка[Колонка.Имя] <> NULL Тогда
						Строка[НовКолонка.Имя] = "("+Строка[Колонка.Имя]+")";
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
			КолонкиКУдалению.Добавить(Колонка);
			
		КонецЕсли;
		
	КонецЦикла;
	
	
	Для каждого Колонка ИЗ КолонкиКУдалению Цикл
		тзВремТаблица.Колонки.Удалить(Колонка);
	КонецЦикла;
	
	
	НовКолонки	= Новый Структура;
	МассивНовыхРеквизитов      = Новый Массив;	
	МассивУдаляемыхРеквизитов  = Новый Массив;
	МассивЭлементовДляУдаления = Новый Массив;
	
	Если ТипЗнч(тзВремТаблица) = Тип("ТаблицаЗначений") Тогда
		
		Элементы.ТЗРезультат.Видимость = Истина;
		Элементы.ДЗРезультат.Видимость = Ложь;
		МассивИмеющихсяРеквизитов = ПолучитьРеквизиты("ТЗРезультат");	
		
		Для Каждого Реквизит Из МассивИмеющихсяРеквизитов Цикл
			Если Реквизит.Имя = "К" Тогда
				Продолжить;
			КонецЕсли;
			МассивУдаляемыхРеквизитов.Добавить("ТЗРезультат."+Реквизит.Имя);	
		КонецЦикла; 
		
		Для Каждого Колонка ИЗ тзВремТаблица.Колонки Цикл
			НовКолонки.Вставить(Колонка.Имя);
			НовыйРеквизит = Новый РеквизитФормы(Колонка.Имя,Колонка.ТипЗначения,"ТЗРезультат");
			МассивНовыхРеквизитов.Добавить(НовыйРеквизит);
		КонецЦикла;	
		
		// Удалим элементы формы 
		Для Каждого ЭлементТаблицы Из Элементы.ТЗРезультат.ПодчиненныеЭлементы Цикл
			Если ЭлементТаблицы.Имя	= "ТЗРезультатК" Тогда
				Продолжить;
			КонецЕсли;
			МассивЭлементовДляУдаления.Добавить(ЭлементТаблицы);		
		КонецЦикла; 
		
		Для Каждого Элемент Из МассивЭлементовДляУдаления Цикл
			Элементы.Удалить(Элемент);	
		КонецЦикла;	
		
		ИзменитьРеквизиты(МассивНовыхРеквизитов,МассивУдаляемыхРеквизитов);	
		
		// создадим элементы
		Для Каждого Колонка Из тзВремТаблица.Колонки  Цикл 
			Элемент	= Элементы.Добавить("ТЗРезультат"+Колонка.Имя,Тип("ПолеФормы"),Элементы.ТЗРезультат);
			Элемент.ПутьКДанным	= "ТЗРезультат."+Колонка.Имя;   
		КонецЦикла;
		
		тзВремТаблица.Колонки.Добавить("К");
		Если тзВремТаблица.Количество() > 0 Тогда
			Элементы.ТЗРезультатК.Заголовок = "0/ "+тзВремТаблица.Количество();
			
			ВремяВыполненияЗапроса = ВремяВыполненияЗапроса + "; "+тзВремТаблица.Количество() + " стр.";
			
		Иначе
			Элементы.ТЗРезультатК.Заголовок = "0/0";
		КонецЕсли;
		
		ЗначениеВДанныеФормы(тзВремТаблица,ТЗРезультат);
		 
		мВыделеноСтрок = 0;
		
	Иначе
		Элементы.ТЗРезультат.Видимость = Ложь;
		Элементы.ДЗРезультат.Видимость = Истина;
		МассивИмеющихсяРеквизитов = ПолучитьРеквизиты("ДЗРезультат");	
		Для Каждого Реквизит Из МассивИмеющихсяРеквизитов Цикл
			Если Реквизит.Имя = "К" Тогда
				Продолжить;
			КонецЕсли;
			МассивУдаляемыхРеквизитов.Добавить("ДЗРезультат."+Реквизит.Имя);	
		КонецЦикла; 
		
		Для Каждого Колонка ИЗ тзВремТаблица.Колонки Цикл
			НовКолонки.Вставить(Колонка.Имя);
			НовыйРеквизит = Новый РеквизитФормы(Колонка.Имя,Колонка.ТипЗначения,"ДЗРезультат");
			МассивНовыхРеквизитов.Добавить(НовыйРеквизит);
		КонецЦикла;	
		
		// Удалим элементы формы 
		Для Каждого ЭлементТаблицы Из Элементы.ДЗРезультат.ПодчиненныеЭлементы Цикл
			Если ЭлементТаблицы.Имя	= "ДЗРезультатК" Тогда
				Продолжить;
			КонецЕсли;
			МассивЭлементовДляУдаления.Добавить(ЭлементТаблицы);		
		КонецЦикла; 
		
		Для Каждого Элемент Из МассивЭлементовДляУдаления Цикл
			Элементы.Удалить(Элемент);	
		КонецЦикла;	
		
		ИзменитьРеквизиты(МассивНовыхРеквизитов,МассивУдаляемыхРеквизитов);	
		
		// создадим элементы
		Для Каждого Колонка Из тзВремТаблица.Колонки  Цикл 
			Элемент	= Элементы.Добавить("ДЗРезультат"+Колонка.Имя,Тип("ПолеФормы"),Элементы.ДЗРезультат);
			Элемент.ПутьКДанным	= "ДЗРезультат."+Колонка.Имя;   
		КонецЦикла;
		
		тзВремТаблица.Колонки.Добавить("К");
		Если тзВремТаблица.Строки.Количество() > 0 Тогда
			Элементы.ДЗРезультатК.Заголовок = "0/ "+тзВремТаблица.Строки.Количество();
			
			ВремяВыполненияЗапроса = ВремяВыполненияЗапроса + "; "+тзВремТаблица.Строки.Количество() + " итог.стр.";
			
		Иначе
			Элементы.ТЗРезультатК.Заголовок = "0/0";
		КонецЕсли;
		
		ЗначениеВДанныеФормы(тзВремТаблица,ДЗРезультат);
		 
		мВыделеноСтрок = 0;
		
	КонецЕсли;

	
	Если ПоказатьВременныеТаблицы Тогда
		Элементы.ГруппаСтраницыРезультат.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
		
		
		ТабДок = ТабВременныеТаблицы;
		ТабДок.Очистить();
		ТабДок.НачатьАвтогруппировкуСтрок();
		
		Макет = РеквизитФормыВЗначение("Объект").ПолучитьМакет("ВременныеТаблицы");
		
		ОблЗаголовок = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
		ОблКолонка   = Макет.ПолучитьОбласть("Колонка");
		ОблЗначение  = Макет.ПолучитьОбласть("Значение");
		ОблНачалоСтроки = Макет.ПолучитьОбласть("НачалоСтроки");
		
		
		СтрокаПоиска = ВРЕГ(Запрос.Текст);
		
		СтрокаПоиска = СтрЗаменить(СтрокаПоиска, Символы.ПС, "");
		СтрокаПоиска = СтрЗаменить(СтрокаПоиска, "     ", " ");
		СтрокаПоиска = СтрЗаменить(СтрокаПоиска, "    ", " ");
		СтрокаПоиска = СтрЗаменить(СтрокаПоиска, "   ", " ");
		СтрокаПоиска = СтрЗаменить(СтрокаПоиска, "  ", " ");
		СтрокаПоиска = СтрЗаменить(СтрокаПоиска, "  ", " ");
		СтрокаПоиска = СтрЗаменить(СтрокаПоиска, "  ", " ");
		
		ВыведеноТаблиц = 0;
		
		
		Пока Истина Цикл
			
			ПозицияПоместить = Найти(СтрокаПоиска, "ПОМЕСТИТЬ "); 
			
			Если ПозицияПоместить = 0 Тогда
				Прервать;
			КонецЕсли;
			
			СтрокаПоиска = СОКРЛП(Сред(СтрокаПоиска, ПозицияПоместить+10));
			
			ПозицияПробела = Найти(СтрокаПоиска, " ");
			
			СтрокаПоискаИЗ = СОКРЛП(Сред(СтрокаПоиска, ПозицияПробела));
			
			ПозицияИз = Найти(СтрокаПоискаИЗ, "ИЗ");
			ПозицияТочки = Найти(СтрокаПоискаИЗ, ";"); 
			
			ИмяТаблицы = СОКРЛП(Лев(СтрокаПоиска, ПозицияПробела+Мин(ПозицияИз, ПозицияТочки)-1)); 
			
			Если Найти(СтрокаПоиска, "УНИЧТОЖИТЬ " + ИмяТаблицы) > 0 Тогда
				Продолжить;
			КонецЕсли;
			
			ОблЗаголовок.Параметры.НазваниеТаблицы = ИмяТаблицы;
			
			
			ТабДок.Вывести(ОблЗаголовок,1);
			
			Запрос.Текст = "ВЫБРАТЬ * ИЗ " + ИмяТаблицы;
			тзВремТаблица = Запрос.Выполнить().Выгрузить();
			
			Если Не тзВремТаблица.Количество() = 0 Тогда
				
				ТабДок.Вывести(ОблНачалоСтроки,1);
				
				ОблКолонка.Параметры.Колонка = "Номер строки";
				ТабДок.Присоединить(ОблКолонка);
				
				Для каждого Колонка Из тзВремТаблица.Колонки Цикл
					
					ОблКолонка.Параметры.Колонка = Колонка.Имя;
					ТабДок.Присоединить(ОблКолонка);
				
					
				КонецЦикла;
				
				НомерСтроки = 1;
				Для каждого Строка ИЗ тзВремТаблица Цикл
					
					ТабДок.Вывести(ОблНачалоСтроки,2);
					
					ОблЗначение.Параметры.Значение = НомерСтроки;
					ТабДок.Присоединить(ОблЗначение);
					
					Для каждого Колонка Из тзВремТаблица.Колонки Цикл
						
						ОблЗначение.Параметры.Значение = Строка[Колонка.Имя];
						ТабДок.Присоединить(ОблЗначение);
					
						
					КонецЦикла;

					
					НомерСтроки = НомерСтроки + 1;
					
				КонецЦикла;
				
			
			КонецЕсли;
			
			
			ВыведеноТаблиц = ВыведеноТаблиц +1;
			
	
		КонецЦикла;		
		
		ТабДок.ЗакончитьАвтогруппировкуСтрок();
		табДок.ПоказатьУровеньГруппировокСтрок(0);
		
		Если ВыведеноТаблиц = 0 Тогда
			Элементы.ГруппаСтраницыРезультат.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
			Элементы.ГруппаСтраницыРезультат.ТекущаяСтраница = Элементы.Группа11;
		КонецЕсли;
		
	Иначе
		Элементы.ГруппаСтраницыРезультат.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		Элементы.ГруппаСтраницыРезультат.ТекущаяСтраница = Элементы.Группа11;
	КонецЕсли;
	
	
	
КонецПроцедуры

&НаСервере
Процедура ИсправитьДеревоЗначений(Строки, СтарКолонка, НовКолонка, Тип)
	Для каждого Строка ИЗ Строки Цикл
		Если Строка[СтарКолонка] <> NULL Тогда
			Если Тип = "Таблица" Тогда
				Строка[НовКолонка] = "Таблица значений ("+Строка[СтарКолонка].Количество()+")";
			ИначеЕсли Тип = "МоментВремени" Тогда
				Строка[НовКолонка] = "("+Строка[СтарКолонка]+")";

			КонецЕсли;
		КонецЕсли;
		ИсправитьДеревоЗначений(Строка.Строки, СтарКолонка, НовКолонка, Тип);
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Процедура ДополнитьПараметрыНаСервере()
	мТекстЗапроса = ТекстЗапроса.ПолучитьТекст();
	
	Если мТекстЗапроса = "" Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(мТекстЗапроса);
	Попытка
		ПараметрыЗапроса = Запрос.НайтиПараметры();
	Исключение
		Сообщить("Возникла ошибка при получении параметров запроса");
		Возврат;
	КонецПопытки;
	
	Для каждого ПараметрЗапроса ИЗ ПараметрыЗапроса Цикл
		
		ИмяПараметра =  ПараметрЗапроса.Имя;
		СтрокиПараметров = ТаблицаПараметров.НайтиСтроки(Новый Структура("Параметр", ИмяПараметра));
		Если СтрокиПараметров.Количество()=0 Тогда
			СтрокаПараметров = ТаблицаПараметров.Добавить();
			СтрокаПараметров.Параметр = ИмяПараметра;
		Иначе
			СтрокаПараметров = СтрокиПараметров[0];
		КонецЕсли; 
		СтрокаПараметров.Значение = ПараметрЗапроса.ТипЗначения.ПривестиЗначение(СтрокаПараметров.Значение);	
		
	КонецЦикла;
	
	ТаблицаПараметров.Сортировать("Параметр");
	
	

КонецПроцедуры

&НаКлиенте
Процедура ДополнитьПараметры(Команда)
	ДополнитьПараметрыНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПереносСтроки(Команда)
	
	НовыйТекст = "";
	Для Ном = 1 По ТекстЗапроса.КоличествоСтрок() Цикл
    	НовыйТекст = НовыйТекст + "|" + ТекстЗапроса.ПолучитьСтроку(Ном) + Символы.ПС;
    КонецЦикла;
    
    ТекстЗапроса.УстановитьТекст(СокрЛП(НовыйТекст));

КонецПроцедуры

&НаКлиенте
Процедура УбратьПереносСтроки(Команда)
	
	ТекстЗапроса.УстановитьТекст(СтрЗаменить(ТекстЗапроса.ПолучитьТекст(), "|", ""));

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКонструкторЗапроса(Команда)
	
	мТекст = ТекстЗапроса.ПолучитьТекст();
	Если СокрЛП(мТекст) = "" Тогда
		Конструктор = Новый КонструкторЗапроса();
	Иначе
		Конструктор = Новый КонструкторЗапроса(мТекст);
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьКонструкторЗапросаЗавершение", ЭтаФорма);
	Конструктор.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте 
Процедура ОткрытьКонструкторЗапросаЗавершение(Результат, ДопПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекстЗапроса.УстановитьТекст(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьКодЗапроса(Команда)
		
	
	мТекстЗапроса = ТекстЗапроса.ПолучитьТекст();
	мТекстЗапроса = СокрЛП(мТекстЗапроса);
	мТекстЗапроса = СтрЗаменить(мТекстЗапроса, Символы.ПС, Символы.ПС + "	|");
	мТекстЗапроса = СтрЗаменить(мТекстЗапроса, """", """""");
	
	КодДляЗапроса = 
	"Запрос = Новый Запрос;
	|Запрос.Текст = 
	|	"""+ мТекстЗапроса +""";
	|
	|";
	
	
	Для каждого Параметр ИЗ ТаблицаПараметров Цикл
		КодДляЗапроса = КодДляЗапроса + "Запрос.УстановитьПараметр("""+Параметр.Параметр+""","""+Параметр.Значение+""");" + Символы.ПС;
	КонецЦикла;
	
	
	КодДляЗапроса = КодДляЗапроса + "
	|Выборка = Запрос.Выполнить().Выбрать();
	|Пока Выборка.Следующий() Цикл
	|	
	|КонецЦикла;";
	
	
	ФормаТекстаЗапроса = ПолучитьФорму("ВнешняяОбработка.КонсольЗапросов.Форма.ФормаТекстаЗапросаУпр");
	ФормаТекстаЗапроса.КодДляЗапроса = КодДляЗапроса;
	ФормаТекстаЗапроса.Открыть();
	
КонецПроцедуры

/////////////////////////////////////////////////
// РАБОТА С ПАРАМЕТРАМИ ЗАПРОСА

&НаКлиенте
Процедура ПолучитьПараметры(Команда)
	
	ПолучитьПараметрыНаСервере();

КонецПроцедуры

&НаСервере
Процедура ПолучитьПараметрыНаСервере()

	мТекстЗапроса = ТекстЗапроса.ПолучитьТекст();
	
	Если мТекстЗапроса = "" Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(мТекстЗапроса);
	Попытка
		ПараметрыЗапроса = Запрос.НайтиПараметры();
	Исключение
		Сообщить("Возникла ошибка при получении параметров запроса");
		Возврат;
	КонецПопытки;
	
	ТаблицаПараметров.Очистить();
	
	Для каждого ПараметрЗапроса ИЗ ПараметрыЗапроса Цикл
		
		ИмяПараметра =  ПараметрЗапроса.Имя;
		СтрокиПараметров = ТаблицаПараметров.НайтиСтроки(Новый Структура("Параметр", ИмяПараметра));
		Если СтрокиПараметров.Количество()=0 Тогда
			СтрокаПараметров = ТаблицаПараметров.Добавить();
			СтрокаПараметров.Параметр = ИмяПараметра;
		Иначе
			СтрокаПараметров = СтрокиПараметров[0];
		КонецЕсли; 
		СтрокаПараметров.Значение = ПараметрЗапроса.ТипЗначения.ПривестиЗначение(СтрокаПараметров.Значение);	
		
	КонецЦикла;
	
	ТаблицаПараметров.Сортировать("Параметр");
	
	

	
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	ВыполнитьТекущийЗапрос();
КонецПроцедуры

/////////////////////////////////////////////////
// РАБОТА СО СПИСКОМ ЗАПРОСА

&НаКлиенте
Процедура СписокЗапросовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если СокрЛП(ТекстЗапроса.ПолучитьТекст()) = "" Тогда
		ПоказатьПредупреждение(,"Не указан текст запроса");
		Возврат;
	КонецЕсли;
	
	ВыполнитьТекущийЗапрос();	
	
	Заголовок = Элементы.СписокЗапросов.ТекущиеДанные.Запрос;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЗапросовПриАктивизацииСтроки(Элемент)
	
	СохранитьТекущийЗапрос();
	
	ТекущиеДанные = Элементы.СписокЗапросов.ТекущиеДанные;
	НомерТекущейСтроки = Элементы.СписокЗапросов.ТекущаяСтрока;
	
	ТекстЗапроса.УстановитьТекст(ТекущиеДанные.ТекстЗапроса);
	ИсходнаяТаблицаПараметров = ТекущиеДанные.Параметры;
	Если НЕ ЕдиныеПараметры Тогда
		ТаблицаПараметров.Очистить();
		Если ИсходнаяТаблицаПараметров <> Неопределено Тогда
			Для каждого СтрокаИсходнойТаблицы ИЗ ИсходнаяТаблицаПараметров Цикл
				НоваяСтрока = ТаблицаПараметров.Добавить();
				НоваяСтрока.Параметр = СтрокаИсходнойТаблицы.Параметр; // Имя параметра
				НоваяСтрока.ЭтоВыражение = СтрокаИсходнойТаблицы.ЭтоВыражение; // Служебный параметр для совместимости
				НоваяСтрока.Значение = СтрокаИсходнойТаблицы.Значение; // Значение
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	

КонецПроцедуры

&НаСервере
Процедура СохранитьТекущийЗапрос()
	
	СтарСтрока = СписокЗапросов.НайтиПоИдентификатору(НомерТекущейСтроки);
	
	Если СтарСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;

	СтарСтрока.ТекстЗапроса = ТекстЗапроса.ПолучитьТекст();
	СтарСтрока.Параметры.Загрузить(ТаблицаПараметров.Выгрузить());
		
	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЗапросовПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Если Элементы.СписокЗапросов.ТекущиеДанные.Запрос = "" Тогда
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ПолучитьИмяЗапроса(знач ТекстЗапроса)
	Если ПустаяСтрока(ТекстЗапроса) Тогда
		Возврат "";
	КонецЕсли;
	
	// Поиск зарезервированного слова "ВЫБРАТЬ".
	Выбрать		= "ВЫБРАТЬ";
	ДлинаВыбрать	= СтрДлина(Выбрать);
	ПозицияВыбрать	= Найти(ВРег(ТекстЗапроса), Выбрать);
	Если ПозицияВыбрать = 0 Тогда
		Возврат "";
	КонецЕсли;	
	
	// Срез строки текста запроса без зарезервированного слова "ВЫБРАТЬ".
	ДлинаЗапроса    = СтрДлина(ТекстЗапроса);
	ТекстЗапроса 	= Сред(ТекстЗапроса, ПозицияВыбрать + ДлинаВыбрать);
	
	// Поиск первой "точки", чтобы определить имя таблицы.                                                  
	Точка			= ".";
	ДлинаТочка		= СтрДлина(Точка);
	ПозицияТочка 	= Найти(ВРег(ТекстЗапроса), Точка);
	Если ПозицияТочка = 0 Тогда
		Возврат "";
	КонецЕсли;
	
	// Возвращается "Запрос:" и имя первой таблицы.
	ВозврЗнач = СокрЛП(Лев(ТекстЗапроса, ПозицияТочка - ДлинаТочка));
	
	ВозврЗнач = СтрЗаменить(ВозврЗнач, Символы.ПС, " ");
	ВозврЗнач = СтрЗаменить(ВозврЗнач, "(", " ");
	ВозврЗнач = СтрЗаменить(ВозврЗнач, ")", " ");
	Если Найти(ВозврЗнач, " ") > 0 Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат "Запрос: "+ВозврЗнач;

КонецФункции	

&НаКлиенте
Процедура СписокЗапросовПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	ТекДанные = Элементы.СписокЗапросов.ТекущиеДанные;
	Если Копирование Тогда
		ТекДанные.Запрос = ТекДанные.Запрос + " (Копия)";
		
		ТекущиеДанные = Элементы.СписокЗапросов.ТекущиеДанные;
		НомерТекущейСтроки = Элементы.СписокЗапросов.ТекущаяСтрока;
		
		ТекстЗапроса.УстановитьТекст(ТекущиеДанные.ТекстЗапроса);
		ИсходнаяТаблицаПараметров = ТекущиеДанные.Параметры;
		Если НЕ ЕдиныеПараметры Тогда
			ТаблицаПараметров.Очистить();
			Если ИсходнаяТаблицаПараметров <> Неопределено Тогда
				Для каждого СтрокаИсходнойТаблицы ИЗ ИсходнаяТаблицаПараметров Цикл
					НоваяСтрока = ТаблицаПараметров.Добавить();
					НоваяСтрока.Параметр = СтрокаИсходнойТаблицы.Параметр; // Имя параметра
					НоваяСтрока.ЭтоВыражение = СтрокаИсходнойТаблицы.ЭтоВыражение; // Служебный параметр для совместимости
					НоваяСтрока.Значение = СтрокаИсходнойТаблицы.Значение; // Значение
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;

		
		
	ИначеЕсли НоваяСтрока Тогда
		ТекДанные.Запрос = "Новый запрос";
	КонецЕсли;
КонецПроцедуры

/////////////////////////////////////////////////
// РАБОТА С РЕЗУЛЬТАТОМ ЗАПРОСА

&НаКлиенте
Процедура ТЗРезультатВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ИмяПоля = СтрЗаменить(Поле.Имя, "ТЗРезультат", "");
	Если ИмяПоля = "К" Тогда
		Если ТЗРезультат.НайтиПоИдентификатору(ВыбраннаяСтрока)[ИмяПоля] = "*" Тогда
			ТЗРезультат.НайтиПоИдентификатору(ВыбраннаяСтрока)[ИмяПоля] = "";
			мВыделеноСтрок = мВыделеноСтрок - 1;
		Иначе
			ТЗРезультат.НайтиПоИдентификатору(ВыбраннаяСтрока)[ИмяПоля] = "*";
			мВыделеноСтрок = мВыделеноСтрок + 1;
		КонецЕсли;
		Элементы.ТЗРезультатК.Заголовок = ""+мВыделеноСтрок + Сред(Элементы.ТЗРезультатК.Заголовок, Найти(Элементы.ТЗРезультатК.Заголовок, "/"));

	Иначе
		ОткрытьЗначение(ТЗРезультат.НайтиПоИдентификатору(ВыбраннаяСтрока)[ИмяПоля]);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДЗРезультатВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ИмяПоля = СтрЗаменить(Поле.Имя, "ДЗРезультат", "");
	Если ИмяПоля = "К" Тогда
		Если ДЗРезультат.НайтиПоИдентификатору(ВыбраннаяСтрока)[ИмяПоля] = "*" Тогда
			ДЗРезультат.НайтиПоИдентификатору(ВыбраннаяСтрока)[ИмяПоля] = "";
			мВыделеноСтрок = мВыделеноСтрок - 1;
		Иначе
			ДЗРезультат.НайтиПоИдентификатору(ВыбраннаяСтрока)[ИмяПоля] = "*";
			мВыделеноСтрок = мВыделеноСтрок + 1;
		КонецЕсли;
		Элементы.ДЗРезультатК.Заголовок = ""+мВыделеноСтрок + Сред(Элементы.ДЗРезультатК.Заголовок, Найти(Элементы.ДЗРезультатК.Заголовок, "/"));

	Иначе
		ОткрытьЗначение(ДЗРезультат.НайтиПоИдентификатору(ВыбраннаяСтрока)[ИмяПоля]);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьУИД(Команда)
	
	ТекПоле = СтрЗаменить(Элементы.ТЗРезультат.ТекущийЭлемент.Имя, "ТЗРезультат", "");
	Значение  =  Элементы.ТЗРезультат.ТекущиеДанные[ТекПоле];
	
	Попытка
		Сообщить("" + Значение + ", УИД: " + Значение.УникальныйИдентификатор());
	Исключение
		
	КонецПопытки;
	
КонецПроцедуры

/////////////////////////////////////////////////
// СОХРАНЕНИЕ

&НаКлиенте
Процедура ИмяФайлаДляСохраненияНастроекНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.ПолноеИмяФайла = ИмяФайлаДляСохраненияНастроек;
	ДиалогОткрытияФайла.Заголовок = "Укажите файл для списка запросов";
	ДиалогОткрытияФайла.Фильтр = "Файлы запросов (*.sel)|*.sel|Все файлы (*.*)|*.*";
	ДиалогОткрытияФайла.Расширение = "sel";
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		ИмяФайлаДляСохраненияНастроек = ДиалогОткрытияФайла.ПолноеИмяФайла;
		ВосстановитьСписокЗапросов();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СохранитьСписокЗапросов()

	СохранитьТекущийЗапрос();

	Если ИмяФайлаДляСохраненияНастроек = "" Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ СохранятьЗапросы Тогда
		Возврат;
	КонецЕсли;
	
	
	АдресВХранилище = СохранитьСписокЗапросовНаСервере();
	
	ДвДанные = ПолучитьИзВременногоХранилища(АдресВХранилище);	
	Попытка
		ДвДанные.Записать(ИмяФайлаДляСохраненияНастроек);
	Исключение
		
	КонецПопытки;
	
	
КонецПроцедуры

&НаСервере
Функция СохранитьСписокЗапросовНаСервере()
	
	СписокДляСохнанения = СписокЗапросов.Выгрузить();
	СписокДляСохнанения.Колонки.Добавить("Параметры");
	ТабПараметры = Новый ТаблицаЗначений();
	ТабПараметры.Колонки.Добавить("Параметр");
	ТабПараметры.Колонки.Добавить("ЭтоВыражение");
	ТабПараметры.Колонки.Добавить("Значение");
	
	сч = 0;
	Для каждого Запрос ИЗ СписокЗапросов Цикл
		ТабПараметры.Очистить();
		Для каждого Параметр ИЗ Запрос.Параметры Цикл
			НовПараметр = ТабПараметры.Добавить();
			ЗаполнитьЗначенияСвойств(НовПараметр, Параметр);
		КонецЦикла;
		СписокДляСохнанения[сч].Параметры = ТабПараметры.Скопировать();
		сч = сч+1;
	КонецЦикла;
	
	ИмяВремФайла = ПолучитьИмяВременногоФайла("tmp");
	ЗначениеВФайл(ИмяВремФайла, СписокДляСохнанения);
	ДвДанные = Новый ДвоичныеДанные(ИмяВремФайла);
	Возврат ПоместитьВоВременноеХранилище(ДвДанные,УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ВосстановитьСписокЗапросов()
	
	
	
	ФайлЗначения = Новый Файл(ИмяФайлаДляСохраненияНастроек);
	Если НЕ ФайлЗначения.Существует() Тогда
		Возврат;
	КонецЕсли;
	
	АдресВХранилище = "";
	ПоместитьФайл(АдресВХранилище, ИмяФайлаДляСохраненияНастроек, ,Ложь, УникальныйИдентификатор);
	
	ВосстановитьСписокЗапросовНаСервере(АдресВХранилище);
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьСписокЗапросовНаСервере(АдресВХранилище)
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла(".tmp");
	ПолучитьИзВременногоХранилища(АдресВХранилище).Записать(ИмяВременногоФайла);
	ПолученноеЗначение = ЗначениеИзФайла(ИмяВременногоФайла);
	
	Если ТипЗнч(ПолученноеЗначение) = Тип("ТаблицаЗначений") Тогда

		СписокЗапросов.Очистить();
		Для каждого СтрокаВремТаблицы из ПолученноеЗначение Цикл
			НовСтрока = СписокЗапросов.Добавить();
			НовСтрока.Запрос = СтрокаВремТаблицы[0]; // Запрос
			НовСтрока.ТекстЗапроса = СтрокаВремТаблицы[1]; // ТекстЗапроса
			Для каждого СтрокаПараметр ИЗ СтрокаВремТаблицы[2] Цикл
				НовыйПараметр = НовСтрока.Параметры.Добавить();
				НовыйПараметр.Параметр = СтрокаПараметр[0];
				НовыйПараметр.ЭтоВыражение = СтрокаПараметр[1]; 
				НовыйПараметр.Значение = СтрокаПараметр[2]; 
			КонецЦикла;

		КонецЦикла;
		мТекущаяСтрока = Неопределено;

	ИначеЕсли ТипЗнч(ПолученноеЗначение) = Тип("ДеревоЗначений") Тогда

		СписокЗапросов.Очистить();
		СкопироватьДеревоЗапросов(ПолученноеЗначение);
		мТекущаяСтрока = Неопределено;

	Иначе // Формат файла не опознан
		Сообщить("Невозможно загрузить список запросов из указанного файла!
					   |Выберите другой файл.");

	КонецЕсли;

	
КонецПроцедуры

&НаСервере
Процедура СкопироватьДеревоЗапросов(ИсходноеДерево)

	Если ИсходноеДерево.Строки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	Для каждого СтрокаДерева из ИсходноеДерево.Строки Цикл

		НоваяСтрока = СписокЗапросов.Добавить();
		НоваяСтрока.Запрос = СтрокаДерева[0]; // Запрос
		НоваяСтрока.ТекстЗапроса = СтрокаДерева[1]; // ТекстЗапроса
		Для каждого СтрокаПараметр ИЗ СтрокаДерева[2] Цикл
			НовыйПараметр = НоваяСтрока.Параметры.Добавить();
			НовыйПараметр.Параметр = СтрокаПараметр[0];
			НовыйПараметр.ЭтоВыражение = СтрокаПараметр[1]; 
			НовыйПараметр.Значение = СтрокаПараметр[2]; 
		КонецЦикла;
			
		СкопироватьДеревоЗапросов(СтрокаДерева);
		
	КонецЦикла;

КонецПроцедуры // СкопироватьДеревоЗапросов()

&НаСервере
Процедура СохранитьНастройкиНаСервере()
	ХранилищеНастроекДанныхФорм.Сохранить("RequestConsoleZR.ИмяФайлаДляСохраненияНастроек",,ИмяФайлаДляСохраненияНастроек,ИмяПользователя());
	ХранилищеНастроекДанныхФорм.Сохранить("RequestConsoleZR.СохранятьЗапросы",,СохранятьЗапросы,ИмяПользователя());
	ХранилищеНастроекДанныхФорм.Сохранить("RequestConsoleZR.ОткрыватьПриОткрытии",,ОткрыватьПриОткрытии,ИмяПользователя());
КонецПроцедуры

/////////////////////////////////////////////////
// НАСТРОЙКА ПЕНЕЛЕЙ

&НаКлиенте   
Процедура СкрытьПараметры(Команда)
	
	Если Элементы.Группа3.Видимость Тогда
		Элементы.Группа3.Видимость = Ложь;
		Элементы.ФормаСкрытьПараметры.Заголовок = "Показать параметры";
	Иначе
		Элементы.Группа3.Видимость = Истина;
		Элементы.ФормаСкрытьПараметры.Заголовок = "Скрыть параметры";
	КонецЕсли;	
		
		
КонецПроцедуры

&НаКлиенте
Процедура СкрытьСписокЗапросов(Команда)
		
	Если Элементы.Группа4.Видимость Тогда
		Элементы.Группа4.Видимость = Ложь;
		Элементы.ФормаСкрытьСписокЗапросов.Заголовок = "Показать список запросов";
	Иначе
		Элементы.Группа4.Видимость = Истина;
		Элементы.ФормаСкрытьСписокЗапросов.Заголовок = "Скрыть список запросов";
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьТекстЗапроса(Команда)
	Если Элементы.ТекстЗапроса.Видимость Тогда
		Элементы.ТекстЗапроса.Видимость = Ложь;
		Элементы.ФормаСкрытьТекстЗапроса.Заголовок = "Показать текст запроса";
	Иначе
		Элементы.ТекстЗапроса.Видимость = Истина;
		Элементы.ФормаСкрытьТекстЗапроса.Заголовок = "Скрыть текст запроса";
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура СкрытьРезультаты(Команда)
	Если Элементы.Группа8.Видимость Тогда
		Элементы.Группа8.Видимость = Ложь;
		Элементы.ФормаСкрытьРезультаты.Заголовок = "Показать результаты";
	Иначе
		Элементы.Группа8.Видимость = Истина;
		Элементы.ФормаСкрытьРезультаты.Заголовок = "Скрыть результаты";
	КонецЕсли;	

КонецПроцедуры

/////////////////////////////////////////////////
// РАБОТА С ФАЙЛАМИ ЗАПРОСОВ

&НаКлиенте
Процедура ОткрыватьПриОткрытии(Команда)
	ОткрыватьПриОткрытии = НЕ ОткрыватьПриОткрытии;
	Элементы.ФормаОткрыватьПриОткрытии.Пометка = ОткрыватьПриОткрытии;
КонецПроцедуры

&НаКлиенте
Процедура АвтоматическоеСохранение(Команда)
	СохранятьЗапросы = НЕ СохранятьЗапросы;
	Элементы.ФормаАвтоматическоеСохранение.Пометка = СохранятьЗапросы;
	
	Если СохранятьЗапросы Тогда
		ПодключитьОбработчикОжидания("СохранитьСписокЗапросов", 60);
	Иначе
		ОтключитьОбработчикОжидания("СохранитьСписокЗапросов");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗапросыИзФайла(Команда)
	
	СтандартнаяОбработка = Ложь;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.ПолноеИмяФайла = ИмяФайлаДляСохраненияНастроек;
	ДиалогОткрытияФайла.Заголовок = "Укажите файл для списка запросов";
	ДиалогОткрытияФайла.Фильтр = "Файлы запросов (*.sel)|*.sel|Все файлы (*.*)|*.*";
	ДиалогОткрытияФайла.Расширение = "sel";
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		ИмяФайлаДляСохраненияНастроек = ДиалогОткрытияФайла.ПолноеИмяФайла;
		ВосстановитьСписокЗапросов();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СохранитьЗапросыВФайл(Команда)
	СтандартнаяОбработка = Ложь;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ДиалогОткрытияФайла.ПолноеИмяФайла = ИмяФайлаДляСохраненияНастроек;
	ДиалогОткрытияФайла.Заголовок = "Укажите файл для списка запросов";
	ДиалогОткрытияФайла.Фильтр = "Файлы запросов (*.sel)|*.sel|Все файлы (*.*)|*.*";
	ДиалогОткрытияФайла.Расширение = "sel";
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		
		ИмяФайлаДляСохраненияНастроек = ДиалогОткрытияФайла.ПолноеИмяФайла;
		
		Если ИмяФайлаДляСохраненияНастроек = "" Тогда
			Возврат;
		КонецЕсли;
		
		СохранитьТекущийЗапрос();

		АдресВХранилище = СохранитьСписокЗапросовНаСервере();
		
		ДвДанные = ПолучитьИзВременногоХранилища(АдресВХранилище);	
		Попытка
			ДвДанные.Записать(ИмяФайлаДляСохраненияНастроек);
		Исключение
			Сообщить(ОписаниеОшибки());	
		КонецПопытки;
		
		
	КонецЕсли;

КонецПроцедуры

