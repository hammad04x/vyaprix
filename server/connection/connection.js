const mysql=require("mysql");

const connection=mysql.createConnection({
    host:"localhost",
    user:"root",
    password:"",
    database:"portfolio"
});



module.exports=connection;