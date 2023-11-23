// this file is used to handle the frontend logic
let totalPages = 0;
let currentPage = 1;

function updateSearchResults(results) {
  const movieList = document.querySelector('.results-grid');
  movieList.innerHTML = '';
  results.forEach((result) => {
    const movieElement = document.createElement('div');
    movieElement.innerHTML = `
    <div class="movie-card">
    <div>
    <img class="movie-image" src="https://image.tmdb.org/t/p/w500${result.poster_path}">
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
        const dataResults = JSON.parse(data.movie);
        totalPages = dataResults.total_pages;
        updateSearchResults(dataResults.results);
        currentPage = dataResults.page;
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

function updatePaginationControls() {
  const paginationNumbers = document.getElementById('page-number');
  paginationNumbers.innerHTML = '';

  for (let i = 1; i <= totalPages; i + 1) {
    const pageElement = document.createElement('p');
    pageElement.innerHTML = i;
    pageElement.addEventListener('click', () => {
      searchMovies(document.getElementById('search-input').value, i);
    });
    if (i === currentPage) {
      pageElement.classList.add('active'); // Highlight the current page
    }
    paginationNumbers.appendChild(pageElement);
  }

  document.getElementById('prev-page').disabled = currentPage === 1;
  document.getElementById('next-page').disabled = currentPage === totalPages;
}

document.getElementById('prev-page').addEventListener('click', () => {
  if (currentPage > 1) {
    searchMovies(
      document.getElementById('search-input').value,
      currentPage - 1,
    );
  }
});

document.getElementById('next-page').addEventListener('click', () => {
  if (currentPage < totalPages) {
    searchMovies(
      document.getElementById('search-input').value,
      currentPage + 1,
    );
  }
});

updatePaginationControls();
