export interface Book {
  bookID: string;
  authors: string[] | undefined;
  title: string;
  description: string | undefined;
  pageCount: number | undefined;
  cover: string | undefined;
  link: string | undefined;
  toString: () => {};
}

export interface History {
  like: boolean;
  dislike: boolean;
  superlike: boolean;
  bookData: Book;
}

export const bookDataToString = (bookData: Book): string => {
  return `{title: ${bookData.title}, description: ${
    bookData.description
  }, authors: ${bookData.authors?.toString()}}`;
};

export const historyToString = (history: History): string => {
  return `{like: ${history.like}, dislike: ${history.dislike}, superlike: ${
    history.superlike
  }, bookData: ${bookDataToString(history.bookData)}}`;
};
