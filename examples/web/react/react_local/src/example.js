import AutoCapture from '@datachecker/autocapture'

const Capture = () => {
    let AC = new AutoCapture();
    AC.init({
        CONTAINER_ID: 'AC_mount',
        LANGUAGE: 'en',
        TOKEN: "<YOUR SDK TOKEN>",
        ASSETS_MODE: "LOCAL",
        ASSETS_FOLDER: "http://localhost:5000/assets",
        onComplete: function (data) {
            console.log(data)
        },
        onError: function(error) {
            console.log(error)
        },
        onUserExit: function () {
            window.history.back()
        }
    })
}


export default Capture;