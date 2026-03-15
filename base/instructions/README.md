# Instructions

`instructions/` хранит сами общие инструкции и политики в нормализованном виде.

## Внутренняя структура

- `core/` - главные portable instructions, которые почти наверняка пойдут во все платформы.
- `workflows/` - task-oriented инструкции и повторяемые playbooks.
- `exceptions/` - случаи, где общий смысл есть, но перенос в платформы требует оговорок.

## Как использовать

1. Сначала описывать здесь общий смысл.
2. Потом связывать его с `schema/` и `mappings/`.
3. После этого переносить в платформенные адаптеры.

## Что сюда класть

- общие repo instructions;
- coding conventions;
- review instructions;
- workflow descriptions;
- reusable checklists.

## Что не класть

- финальные provider-specific файлы;
- машинно-локальные настройки;
- чисто форматные детали без общего смысла.
