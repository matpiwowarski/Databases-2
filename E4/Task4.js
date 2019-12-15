// 1 display NAME, SURNAME, AGE OF EVERY HOST

db.getCollection("lodging").find(
    { 
        "host" : {
            "$exists" : true
        }
    }, 
    {
        "host.name" : 1.0, 
        "host.surname" : 1.0, 
        "host.age" : 1.0
    }
);

