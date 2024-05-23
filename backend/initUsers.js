const bcrypt = require("bcrypt");

const initializeUsers = async () => {
  const users = [
    { username: "admin", password: "$2b$10$SH4kVd0Z9/rCIBstOn.zhuM/3XXX8SIk2LLntR4acY9AjDWMo4Y4i" }, //admin123
    { username: "user1", password: "$2b$10$c65vgl86rNRzHLAWD82tyOjTz78lOmG0G89Kh.z/ApwJYn625R1xG" }, //user1
    { username: "user2", password: await bcrypt.hash("user2", 10) },
  ];
  return users;
};

// (async () => {
//   console.log(await initializeUsers());
// })();

module.exports = initializeUsers;
