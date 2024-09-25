document.addEventListener("turbo:load", function() {
  const searchInput = document.getElementById("search-keyword");
  const autocompleteList = document.getElementById("autocomplete-list");

  searchInput.addEventListener("input", function() {
    const keyword = this.value;
    const searchType = document.querySelector('input[name="search_type"]').value;

    if (keyword.length > 1) {
      fetch(`/ramen_shops/autocomplete?search_type=${searchType}&keyword=${keyword}`)
        .then(response => response.json())
        .then(data => {
          autocompleteList.innerHTML = '';
          data.forEach(item => {
            const listItem = document.createElement("li");
            listItem.textContent = item.name;
            listItem.classList.add("autocomplete-item");

            listItem.addEventListener("click", function() {
              searchInput.value = item.name;
              autocompleteList.innerHTML = '';
            });

            autocompleteList.appendChild(listItem);
          });
        })
        .catch(error => console.error('Error:', error));
    } else {
      autocompleteList.innerHTML = '';
    }
  });

  searchInput.addEventListener("blur", function() {
    setTimeout(function() {
      autocompleteList.innerHTML = '';
    }, 200);
  });
});