const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp(functions.config().firebase);
/* 
exports.determineNearCovidPatient = functions.database
	.ref("Locations/{userId}")
	.onUpdate((change, context) => {
		const userIdMain = context.params.userId;

		let lat1 = 0;
		let lat2 = 0;
		let lon1 = 0;
		let lon2 = 0;

		let promise = admin
			.database()
			.ref(`Covid-19`)
			.once("value")
			.then(snapshot => {
				let covidPeople = snapshot.val();

				let promises = [];

				let promise = admin
					.database()
					.ref(`Locations/${userIdMain}`)
					.once("value");
				promises.push(promise);

				for (person in covidPeople) {
					let promise = admin
						.database()
						.ref(`Locations/${person}`)
						.once("value");
					promises.push(promise);
				}

				return Promise.all(promises);
			})
			.then(snapshots => {
                console.log(`Number of near Covid19 patients: ${snapshots.length}`)
				let locationMain = snapshots[0].val();
				lat1 = locationMain["Latitude"];
				lon1 = locationMain["Longitude"];

				snapshots.forEach(location => {
					lat2 = location.val()["Latitude"];
					lon2 = location.val()["Longitude"];
					let userId = location.key;

					lat1Rad = (lat1 * Math.PI) / 180;
					lon1Rad = (lon1 * Math.PI) / 180;
					lat2Rad = (lat2 * Math.PI) / 180;
					lon2Rad = (lon2 * Math.PI) / 180;

					let dlon = lon2 - lon1;
					let dlat = lat2 - lat1;
					let a =
						Math.sin(dlat / 2) ** 2 + Math.cos(lat1) * Math.cos(lat2) * Math.sin(dlon / 2) ** 2;

					let c = 2 * Math.asin(Math.sqrt(a));

					// Radius of earth in kilometers. Use 3956 for miles
					let r = 6371;

					// calculate the result
					let distance_m = c * r * 1000; // in metres

					if (distance_m !== 0 && distance_m < 5) {
						admin
							.database()
							.ref(`Near/${userId}/${userIdMain}`)
							.set(true);
					}
				});

				return true;
			})
			.catch(error => {
				console.log(error);
				return true;
			});

		/* 
        if (change.after.val() === true) {
        	let promises = [];

        	let lat1 = 0.0;
        	let lon1 = 0.0;

        	let lat1Org = 0.0;
        	let lon1Org = 0.0;

        	let refTokenMain = 0;

        	let promiseReferenceTokenMain = admin
        		.database()
        		.ref(`FCM tokens/users/${userIdMain}`)
        		.once("value");
        	promises.push(promiseReferenceTokenMain);
        	promiseGetMainLocation = admin
        		.database()
        		.ref(`Locations/users/${userIdMain}`)
        		.once("value");
        	promises.push(promiseGetMainLocation);

        	Promise.all(promises)
        		.then(snapshots => {
        			//args[0] has reftokenmain

        			mainLocation = snapshots[1].val();
        			refTokenMain = snapshots[0].val();
        			console.log(`The Main location is `);
        			console.log(mainLocation);

        			lat1 = mainLocation["Latitude"];
        			lon1 = mainLocation["Longitude"];

        			console.log(`lat1=${lat1}, lat2=${lon1}`);
        			return (
        				admin
        					.database()
        					.ref(`Locations/users`)
        					.orderByChild(`Latitude`)
        					// .startAt(lat1 - 0.009009 )
        					// .endAt(lat1 + 0.009009 ))
        					.once("value")
        			);
        		})
        		.then(snapshot => {
        			let tokenList = [];
        			let userIdList = [];

        			let Locations = snapshot.val();
        			console.log(`Getting users near the main location`);
        			console.log(`All users are (latitude filtering):`);
        			console.log(Locations);

        			lat1Org = lat1;
        			lon1Org = lon1;

        			lat1 = (lat1 * Math.PI) / 180;
        			lon1 = (lon1 * Math.PI) / 180;

        			//NOTE collect users to send notification based on distance calculation
        			for (let location in Locations) {
        				let lat2 = Locations[location]["Latitude"];
        				let lon2 = Locations[location]["Longitude"];

        				//Convert Degrees to Radians
        				lat2 = (lat2 * Math.PI) / 180;
        				lon2 = (lon2 * Math.PI) / 180;

        				let d = 0;
        				let distance_km = 0;

        				d = Math.acos(
        					Math.sin(lat1) * Math.sin(lat2) +
        						Math.cos(lat1) * Math.cos(lat2) * Math.cos(lon1 - lon2)
        				);

        				distance_km = 6371 * d;
        				console.log(`User distance: ${distance_km} km`);

        				//REVIEW (lat1,lon1)!=(lat2,lon2)
        				if (distance_km < 1 && (lat1, lon1) !== (lat2, lon2)) {
        					//TODO read FCM token for user and add to array -> 1) send first 2) add first to array, send together

        					userIdList.push(location);
        					console.log(`User added: ${location}`);
        				}
        			}

        			return userIdList;
        		})
        		.then(userIdList => {
        			promises = [];
        			promises2 = [];

        			console.log(`Getting user tokens`);

        			userIdList.forEach(userId => {
        				let promise = admin
        					.database()
        					.ref(`FCM tokens/users/${userId}`)
        					.once("value");
        				promises.push(promise);

        				userCount += 1;

        				promise = admin
        					.database()
        					.ref(`Near/users/${userId}/${userIdMain}`)
        					.set({
        						Latitude: lat1Org,
        						Longitude: lon1Org
        					});

        				promises2.push(promise);
        			});

        			promises2.forEach(promiseLocal => {
        				promises.push(promiseLocal);
        			});

        			return Promise.all(promises);
        		})
        		.then(snapshots => {
        			console.log(`Retrieved user tokens`);

        			tokenList = [];

        			for (let i = 0; i < userCount; i += 1) {
        				tokenList.push(snapshots[i].val());
        			}

        			console.log(`user tokens: ${tokenList}`);
        			console.log(tokenList);

        			return tokenList;
        		})
        		.then(tokenList => {
        			let payload = null;
        			promises = [];

        			console.log(`Generating Payload for users`);

        			//NOTE sends notification to each user
        			tokenList.forEach(refToken => {
        				payload = {
        					notification: {
        						title: "Emergency! Someone nearby needs your help",
        						body: `Someone has activated the emergency service of Difesa app near you. Please try to help the person.\nStart by tapping the notification`
        					},

        					token: refToken,

        					data: {
        						type: "Emergency",
        						Latitude: lat1Org,
        						Longitude: lon1Org
        					}
        				};

        				console.log(`Payload: ${payload}`);
        				console.log(payload);

        				/* const promise = admin.messaging().send(payload);
        				promises.push(promise); */
		/* });
        			return true;
        			// return Promise.all(promises);
        		})
        		.then(results => {
        			console.log(`All done`);

        			return true;
        		})
        		.catch(error => {
        			console.log(`Some error`);

        			console.log(error);
        		});
        } else if (change.after.val() === false) {
        	console.log("emergency stopped");

        	let promise = admin
        		.database()
        		.ref("Near/users")
        		.orderByChild(userIdMain)
        		.startAt(userIdMain)
        		.once("value")
        		.then(snapshot => {
        			console.log(snapshot.val());
        			console.log("inside");

        			promises = [];

        			for (userId in snapshot.val()) {
        				promise = admin
        					.database()
        					.ref(`Near/users/${userId}/${userIdMain}`)
        					.remove();
        				promises.push(promise);
        			}
        			return Promise.all(promises);
        		})
        		.catch(error => {
        			console.log("Some error");
        			console.log(error);
        		});
        } 

		return true;
    }); */
    
    exports.setAlert = functions.database.ref(`Near/{userId}`).onWrite( (snapshot, context) => {

        let userIdMain = context.params.userId;
        let people = snapshot.after;

        let count = 0;

        people.forEach( (data) => {
            count +=1;
        });
        console.log(`Number of people: ${count}`);

        if(count >= 2) {
            admin.database().ref(`Alerts/${userIdMain}`).set(true);
        }

        else {
            admin.database().ref(`Alerts/${userIdMain}`).set(null);
        }

        return true;
        
    });
