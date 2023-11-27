function updateSearchResults(results) {
  const movieList = document.querySelector('.results-grid');
  movieList.innerHTML = '';
  results.forEach((result) => {
    const defaultImage = 'https://via.placeholder.com/500x750?text=No+Image+Available';
    const posterImageURL = result.poster_path
      ? `https://image.tmdb.org/t/p/w500${result.poster_path}`
      : defaultImage;

    const movieElement = document.createElement('div');
    movieElement.innerHTML = `
    <div class="movie-card">
    <div>
    <img class="movie-image" src="${posterImageURL}" alt="${result.title}">
    </div>
    <div class="movie-info">
    <h5 class="movie-title">${result.title}</h5>
    <p class="movie-text">${result.overview}</p>
    </div>
    </div>
    `;
    movieList.appendChild(movieElement);
  });
}

function searchMovies(query, page = 1) {
  fetch(`/search?page=${page}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ query }),
  })
    .then((response) => response.json())
    .then((data) => {
      if (data.error) {
        // Handle the error in the UI
        const errorElement = document.createElement('div');
        errorElement.innerHTML = `
      <div class="error">
      <p>${data.error}</p>
      </div>
      `;
        document.getElementById('notification-area').appendChild(errorElement);
      } else {
        const dataResults = data.movie;
        updateSearchResults(dataResults.results);
      }
    })
    .catch((error) => {
      const errorElement = document.createElement('div');
      errorElement.innerHTML = `
  <div class="error">
  <p>${error.message}</p>
  </div>
  `;
      document.getElementById('notification-area').appendChild(errorElement);
    });
}

document.getElementById('search-button').addEventListener('click', () => {
  const movieName = document.getElementById('search-input').value;
  searchMovies(movieName);
});
