const coffeeList = document.querySelector('#cafe-list');
const form = document.querySelector('#add-cafe-form');


// create element and render coffee
function renderCoffe(doc){
    let li = document.createElement('li');
    let name = document.createElement('span');
    let city = document.createElement('span');
    let cross = document.createElement('div');

    li.setAttribute('data-id', doc.id);
    name.textContent = doc.data().name;
    city.textContent = doc.data().city;
    cross.textContent = 'x';

    li.appendChild(name);
    li.appendChild(city);
    li.appendChild(cross);

    coffeeList.appendChild(li);

    // deleting data
    cross.addEventListener('click', (e) => {
        e.stopPropagation();
        let id = e.target.parentElement.getAttribute('data-id');
        db.collection('coffees').doc(id).delete();
    })
}



//getting data
/*
db.collection('coffees').get().then((snapshot) => {
    snapshot.docs.forEach(doc => {
        renderCoffe(doc);
    })
});

//getting filtered data
db.collection('coffees').where('city', '==', 'london').get().then((snapshot) => {
    snapshot.docs.forEach(doc => {
        renderCoffe(doc);
    })
});

//ordering data
db.collection('coffees').where('city', '==', 'manchester').orderBy('name').get().then((snapshot) => {
    snapshot.docs.forEach(doc => {
        renderCoffe(doc);
    })
});
*/



//saving data
form.addEventListener('submit', (e) => {
    e.preventDefault();
    db.collection('coffees').add({
        name: form.name.value,
        city: form.city.value
    });
    form.name.value = '';
    form.city.value = '';
});

// real time listener

db.collection('coffees').orderBy('city').onSnapshot(snapshot => {
    let changes = snapshot.docChanges();
    changes.forEach(change => {
        console.log(change.doc.data());
        if(change.type == 'added'){
            renderCoffe(change.doc);
        } else if (change.type == 'removed'){
            let li = coffeeList.querySelector('[data-id=' + change.doc.id + ']');
            coffeeList.removeChild(li);
        }
    });
});

/*
//updating (not implemeted in the html file)
db.collection('coffees').doc('id').update({
    name: 'New Name',
});

//completly over-write method
db.collection('coffees').doc('id').set({
    name: 'New Name',
});

*/