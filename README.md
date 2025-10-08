# Readinglist

![Elixir CI](https://github.com/your-username/readinglist/workflows/Elixir%20CI/badge.svg)
[![Elixir](https://img.shields.io/badge/Elixir-4B275F?style=for-the-badge&logo=elixir&logoColor=white)](https://elixir-lang.org/)
[![Phoenix Framework](https://img.shields.io/badge/Phoenix%20Framework-FD4F00?style=for-the-badge&logo=phoenix-framework&logoColor=white)](https://www.phoenixframework.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A personal web application built with Elixir and Phoenix, designed to help you curate and manage your reading list. Whether it's blog posts, articles, or any web content, Readinglist provides a streamlined way to keep track of what you want to read, what you've read, and what you want to keep hidden for later.

## ✨ Features

*   **Personalized Reading Lists**: Create and manage your own collection of articles and blog posts.
*   **Blog Fetcher**: Easily fetch content from external blogs by providing an ID or a range of IDs.
    *   **Range Fetching**: Fetch multiple blog posts in one go, perfect for catching up on a series.
    *   **Error Handling**: Robust error handling during fetching, providing clear feedback on successes and failures.
*   **Content Management**:
    *   **Mark as Read/Unread**: Keep track of your reading progress.
    *   **Hide/Unhide Items**: Toggle the visibility of items to keep your list clutter-free without deleting content.
*   **Filtering & Search**:
    *   **Dynamic Filtering**: Filter your reading list by read status (including, only read, excluding read) and hidden status (including, only hidden, excluding hidden).
    *   **Search Functionality**: Quickly find items by title or description.
*   **User Authentication**: Secure user authentication powered by Phoenix.
*   **Modern UI**: Built with Tailwind CSS and DaisyUI for a clean and responsive user experience.

## 🚀 Technologies Used

*   **Elixir**: A dynamic, functional language designed for building scalable and maintainable applications.
*   **Phoenix Framework**: A productive web framework that does not compromise speed and maintainability.
*   **Phoenix LiveView**: Build rich, interactive user experiences with server-rendered HTML.
*   **Ecto**: A powerful database wrapper and language integrated query for Elixir.
*   **Req**: A simple, powerful HTTP client for Elixir.
*   **Floki**: A simple HTML parser that enables easy scraping and manipulation of HTML.
*   **Tailwind CSS**: A utility-first CSS framework for rapidly building custom designs.
*   **DaisyUI**: A Tailwind CSS component library.

## 📦 Getting Started

To start your Phoenix server:

*   Install dependencies with `mix deps.get`
*   Create and migrate your database with `mix ecto.setup`
*   Install Node.js dependencies with `npm install --prefix assets`
*   Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## 💡 Notes / Ideas / Todo

- the readinglist is a kind of interactive website currently it is only implemented using simple
html methods and no custom js
- the problem is that the updates for hidden and read toggles are slow because the whole site is
fetched again
- this would be a use for live view I might make a live view version of this site (todo)
