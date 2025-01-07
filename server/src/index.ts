import axios from "axios";
import dotenv from "dotenv";
import express, { Request, Response, Application } from "express";
import { initializeApp } from "firebase/app";
import {
  collection,
  doc,
  DocumentData,
  DocumentSnapshot,
  getDocs,
  getFirestore,
  QuerySnapshot,
  setDoc,
} from "firebase/firestore";
import { v4 as uuid } from "uuid";
import { GPTRecommendedBooks } from "./ai";
import { Book, History } from "./types";

dotenv.config();
process.setMaxListeners(0);

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyAg6QDCgK-Eyl4XdJ9j-sLN6EfLuo4gmRM",
  authDomain: "ltc2025-81ee7.firebaseapp.com",
  projectId: "ltc2025-81ee7",
  storageBucket: "ltc2025-81ee7.firebasestorage.app",
  messagingSenderId: "753680020144",
  appId: "1:753680020144:web:c4791185b25e2a0d9c4175",
};

// Initialize Firebase
const firebase = initializeApp(firebaseConfig);
const db = getFirestore(firebase);

const app: Application = express();
const port = process.env.port || 8000;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// BOOK RECOMMENDER
app.get("/books/:user-:num", async (req: Request, res: Response) => {
  const num = parseInt(req.params.num);

  // Get user history
  const userHistory: History[] = [];
  const historySnapshot = await getDocs(
    collection(db, `userHistory/${req.params.user}/history`)
  );
  historySnapshot.docs.forEach((doc: DocumentSnapshot) => {
    if (doc.exists()) {
      const data = doc.data();
      userHistory.push({
        like: data.like,
        dislike: data.dislike,
        superlike: data.superlike,
        bookData: {
          bookID: data.bookData.bookID,
          authors: data.bookData.authors,
          title: data.bookData.title,
          description: data.bookData.description,
          pageCount: data.bookData.pageCount,
          cover: data.bookData.cover,
          link: data.bookData.link,
        },
      });
    }
  });

  // Get user preferences
  const userPreferences: DocumentData[] = [];
  const preferencesSnapshot = await getDocs(
    collection(db, `userHistory/${req.params.user}/history`)
  );
  preferencesSnapshot.docs.forEach((doc: DocumentSnapshot) => {
    if (doc.exists()) {
      userPreferences.push(doc.data());
    }
  });

  // Get a list of book names recommended based on user history
  const booksData: Book[] = await GPTRecommendedBooks(
    userHistory,
    userPreferences,
    num
  );

  res.send(booksData);
});

// SEARCH

app.get(
  "/search/:query-:startIndex-:maxResults",
  async (req: Request, res: Response) => {
    axios
      .get(
        `https://www.googleapis.com/books/v1/volumes?q=intitle:${req.params.query}&maxResults=${req.params.maxResults}&startIndex=${req.params.startIndex}&key=${process.env.BOOKS_APIKEY}`
      )
      .then((response: { data: { items: any[] } }) => {
        const books = response.data.items;
        const booksData: Book[] = [];
        for (let i = 0; i < books.length; i++) {
          const book = response.data.items[i];
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
        res.send(booksData);
      });
  }
);

// SUBJECT SEARCH

app.get(
  "/search/subject/:subject-:startIndex-:maxResults",
  async (req: Request, res: Response) => {
    axios
      .get(
        `https://www.googleapis.com/books/v1/volumes?q=subject:${req.params.subject}&maxResults=${req.params.maxResults}&startIndex=${req.params.startIndex}&key=${process.env.BOOKS_APIKEY}`
      )
      .then((response: { data: { items: any[] } }) => {
        const books = response.data.items;
        const booksData: Book[] = [];
        for (let i = 0; i < books.length; i++) {
          const book = response.data.items[i];
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
        res.send(booksData);
      });
  }
);

// BOOK BY ID

app.get("/books/:id", (req: Request, res: Response) => {
  axios
    .get(
      `https://www.googleapis.com/books/v1/volumes/${req.params.id}?key=${process.env.BOOKS_APIKEY}`
    )
    .then(
      (response: {
        data: {
          id: any;
          volumeInfo: any;
        };
      }) => {
        let book = response.data;
        let bookData: Book = {
          bookID: book.id,
          authors: book.volumeInfo.authors,
          title: book.volumeInfo.title,
          description: book.volumeInfo.description,
          pageCount: book.volumeInfo.pageCount,
          cover:
            book.volumeInfo.imageLinks != undefined
              ? book.volumeInfo.imageLinks.thumbnail
              : null,
          link: `https://books.google.com/books?id=${book.id}`,
        };
        res.send(bookData);
      }
    );
});

// UPDATE HISTORY

app.post("/updateHistory/:userID", (req: Request, res: Response) => {
  const bookID = req.body.bookID;
  axios
    .get(
      `https://www.googleapis.com/books/v1/volumes/${bookID}?key=${process.env.BOOKS_APIKEY}`
    )
    .then(
      (response: {
        data: {
          id: any;
          volumeInfo: any;
        };
      }) => {
        let book = response.data;
        let bookData: Book = {
          bookID: book.id,
          authors: book.volumeInfo.authors ?? null,
          title: book.volumeInfo.title,
          description: book.volumeInfo.description ?? null,
          pageCount: book.volumeInfo.pageCount ?? null,
          cover:
            book.volumeInfo.imageLinks != undefined
              ? book.volumeInfo.imageLinks.thumbnail
              : null,
          link: `https://books.google.com/books?id=${book.id}`,
        };
        if (req.body.superlike) {
          setDoc(
            doc(db, `bookshelves/${req.params.userID}/books`, uuid()),
            bookData
          );
        }
        const newHistory: History = {
          like: req.body.like,
          dislike: req.body.dislike,
          superlike: req.body.superlike,
          bookData: bookData,
        };

        setDoc(
          doc(db, `userHistory/${req.params.userID}/history`, uuid()),
          newHistory
        );
      }
    );
  res.sendStatus(200);
});

// TEST BOOKS
app.get(
  "/testBooks/:user-:startIndex-:maxResults",
  async (req: Request, res: Response) => {
    axios
      .get(
        `https://www.googleapis.com/books/v1/volumes?q=subject:fantasy&maxResults=${req.params.maxResults}&startIndex=${req.params.startIndex}&key=${process.env.BOOKS_APIKEY}`
      )
      .then((response: { data: { items: any[] } }) => {
        const books = response.data.items;
        const booksData: Book[] = [];
        for (let i = 0; i < books.length; i++) {
          const book = response.data.items[i];
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
        res.send(booksData);
      });
  }
);

app.listen(port, () => {
  console.log(`Server is listening at http://localhost:${port}`);
});
