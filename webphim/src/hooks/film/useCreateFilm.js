
const useCreateFilm = () => {
    const createFilm = async (filmInfor) => {
        try {
            const formData = new FormData();
            formData.append('poster', filmInfor.poster_img);
            formData.append('film', JSON.stringify(filmInfor));
            let response;
            try{
                response = await fetch('/Api/api/films/create/', {
                // headers : { 
                //     'Content-Type': 'application/json',
                //     'Accept': 'application/json'
                // },
                method: 'POST',
                credentials: 'include',
                body: formData,
                });
            }catch(error){
                console.error("not able to create film, error : " + error);
            }
            const data = await response.json();
            if (!response.ok) {
                console.log(data?.message);
            }
            console.log(data?.message);
        } catch (error) {
            console.log("Error: "+ error);
        }
    };
    return { createFilm };
};

export default useCreateFilm;
