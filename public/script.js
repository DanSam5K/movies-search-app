// this file is used to handle the frontend logic
document.getElementById('search-button').addEventListener('click', () => {
  const movieName = document.getElementById('search-input').value;

  fetch('/search', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ movieName }),
  })
    .then((res) => res.json())
    .then((data) => {
      const dataResult = JSON.parse(data.movie);
      const movieList = document.querySelector('.results-grid');
      movieList.innerHTML = '';
      dataResult.results.forEach((movie) => {
        const movieElement = document.createElement('div');
        movieElement.innerHTML = `
        <div class="movie-card">
          <div>
            <img class="movie-image" src="https://image.tmdb.org/t/p/w500${movie.poster_path}">
          </div>
          <div class="movie-info">
            <h5 class="movie-title">${movie.title}</h5>
            <p class="movie-text">${movie.overview}</p>
          </div>
        </div>
        `;
        movieList.appendChild(movieElement);
      });
    });
});
