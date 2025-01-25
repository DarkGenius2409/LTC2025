import OpenAI from "openai";
import { Completions } from "openai/resources";
import ollama from "ollama";
import axios from "axios";
import { Book, History, historyToString } from "./types";
import dotenv from "dotenv";

dotenv.config();

export const GPTRecommendedBooks = async (
  _userHistory: History[],
  _userPreferences: any[],
  num: number
): Promise<Book[]> => {
  const openai = new OpenAI({ apiKey: process.env.OPENAI_APIKEY });
  let userHistoryString: string = "";
  _userHistory.forEach((history: History) => {
    return (userHistoryString += historyToString(history));
  });
  const promptWithHistory: string = `${userHistoryString} ${_userPreferences.toString()} Based on the given data, recommend ${num} books that can be found in the Google Books API. The response should not repeat the names of books already mentioned in the given data. All recommended books must not already be in the given data. The response should contain only the names of the ${num} books separated by commas, followed by a semicolon, followed by only the names of the authors of the respective books separated by commas, nothing else. `;
  const promptWithoutHistory: string = `${_userPreferences.toString()} Based on the given data, recommend ${num} books that can be found in the Google Books API. The response should not repeat the names of books already mentioned in the given data. All recommended books must not already be in the given data. The response should contain only the names of the ${num} books separated by commas, followed by a semicolon, followed by only the names of the authors of the respective books separated by commas, nothing else.`;

  const response = await openai.chat.completions.create({
    model: "gpt-4o-mini",
    messages: [
      {
        role: "user",
        content: [
          {
            type: "text",
            text:
              _userHistory.length > 1
                ? promptWithHistory
                : promptWithoutHistory,
          },
        ],
      },
    ],
  });
  let rawOutput = response.choices[0].message.content!;
  console.log(rawOutput);
  rawOutput = rawOutput.replace("\n", "");
  const bookList = rawOutput.split(";")[0];
  const authorList = rawOutput.split(";")[1];
  const bookNames = bookList.replace('"', "").split(",");
  const authorNames = authorList.replace('"', "").split(",");
  return await fetchBooksData(
    _userHistory,
    _userPreferences,
    bookNames,
    authorNames
  );
};

const fetchBooksData = async (
  _userHistory: History[],
  _userPreferences: any[],
  bookNames: string[],
  authorNames: string[]
): Promise<Book[]> => {
  let booksData: Book[] = [];

  for (let i = 0; i < bookNames.length; i++) {
    const bookName = bookNames[i];
    const authorName = authorNames[i];
    const endpoint = `https://www.googleapis.com/books/v1/volumes?q=intitle:${bookName}${
      authorName != undefined ? `+inauthor:${authorName}` : ""
    }&key=${process.env.BOOKS_APIKEY}`;

    const response = await axios.get(endpoint);
    console.log(endpoint);
    if (response.data.totalItems == 0) {
      const bookData = await GPTRecommendedBooks(
        _userHistory,
        _userPreferences,
        1
      );
      booksData.push(bookData[0]);
      continue;
    }

    let book;

    for (let i = 0; i < response.data.totalItems; i++) {
      if (response.data.items[i].title == bookName) {
        book = response.data.items[i];
      }
    }

    const bookData: Book = {
      bookID: book.id,
      authors: book.volumeInfo.authors,
      title: book.volumeInfo.title,
      description: book.volumeInfo.description,
      pageCount: book.volumeInfo.pageCount,
      cover:
        book.volumeInfo.imageLinks != undefined
          ? book.volumeInfo.imageLinks.thumbnail
          : null,
      link: book.volumeInfo.infoLink,
    };
    booksData.push(bookData);
  }
  return booksData;
};
