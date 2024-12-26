/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import { onRequest } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import "axios";
import axios from "axios";
import dotenv from "dotenv";
import express, { Request, Response, Application } from "express";

dotenv.config();

const app: Application = express();

app.get("/:startIndex-:maxResults", (req: Request, res: Response) => {
  logger.info("Hello logs!", { structuredData: true });
  axios
    .get(
      `https://www.googleapis.com/books/v1/volumes?q=subject:fantasy&maxResults=${req.params.maxResults}&orderBy=relevance&startIndex=${req.params.startIndex}&key=${process.env.APIKEY}`
    )
    .then((response) => {
      let books = response.data.items;
      let booksData = [];
      for (let i = 0; i < books.length; i++) {
        let book = response.data.items[i];
        let bookData = {
          id: book.id,
          authors: book.volumeInfo.authors,
          title: book.volumeInfo.title,
          description: book.volumeInfo.description,
          pageCount: book.volumeInfo.pageCount,
          cover: book.volumeInfo.imageLinks.thumbnail,
          link: book.volumeInfo.infoLink,
        };
        booksData.push(bookData);
      }
      res.send(booksData);
    });
});

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

exports.books = onRequest(app);
