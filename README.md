# react-native-amr
Native AMR play for react-native (iOS only)

AMR.stop();

//callback: (error, event: {status}) => void)
// status: 0:playing, 1:play success end, 2:play failed, 3: stop

AMR.play(path, (error, event) => {
    console.log(error);
    console.log(event);
    if (!error) {
        if (event.status === 1) {
            //play success
        } else if(event.status === 3) {
            //stop success
        }
    } else {
        //event.status = 2
        console.log('can't play');
    }
});
