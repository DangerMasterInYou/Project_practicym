var corpuses = {
  "0": "Административный",
  "1": "Первый",
  "2": "Второй",
  "3": "Третий",
  "4": "Четвёртый",
};
var statuses = {
  "0": "Создано",
  "1": "Отклонено",
  "2": "Перенаправлено",
  "3": "Назначено",
  "4": "Выполнено",
  "5": "Завершено",
};
var roles = {
  "0": "User",
  "1": "Developer",
  "2": "Admin",
};
var categories = {
  "0": "Electrician",
  "1": "Carpenter",
  "2": "Plumber",
  "3": "Cleaner",
  "4": "Administator",
};

var users = {
  // Основной мап пользователей
  "0": {
    "login": "user1",
    "password": "qwe123",
    "roleId": "0",
    "categoryId": "999",
  },
  "1": {
    "login": "dev1",
    "password": "qwe123",
    "roleId": "1",
    "categoryId": "0"
  },
  "2": {
    "login": "admin",
    "password": "qwe123",
    "roleId": "2",
    "categoryId": "4",
  },
  "3": {
    "login": "dev2",
    "password": "qwe123",
    "roleId": "1",
    "categoryId": "3",
  },
};

// Основной мап заявок
var applications = {
  "0": {
    "name": "Пролит бензин",
    "senderId": "0",
    "corpusId": "3",
    "cabinet": "316",
    "categoryId": "3",
    "description": "Пролили",
    "pathToPhoto": "",
    "statuseId": "3",
    "developerId": "3",
  },
  "1": {
    "name": "Сломана розетка",
    "senderId": "0",
    "corpusId": "2",
    "cabinet": "155",
    "categoryId": "0",
    "description": "Сломалось",
    "pathToPhoto": "",
    "statuseId": "1",
    "developerId": null,
  },
  "2": {
    "name": "Сломан принтер",
    "senderId": "0",
    "corpusId": "4",
    "cabinet": "351",
    "categoryId": "4",
    "description": "Сломалось",
    "pathToPhoto": "",
    "statuseId": "1",
    "developerId": null,
  },
  "3": {
    "name": "Пролит керосин",
    "senderId": "0",
    "corpusId": "2",
    "cabinet": "222",
    "categoryId": "3",
    "description": "Пролился",
    "pathToPhoto": "",
    "statuseId": "3",
    "developerId": null,
  },
  "4": {
    "name": "Пролит ацетон",
    "senderId": "0",
    "corpusId": "1",
    "cabinet": "111",
    "categoryId": "3",
    "description": "Пролился",
    "pathToPhoto": "",
    "statuseId": "0",
    "developerId": null,
  },
};
