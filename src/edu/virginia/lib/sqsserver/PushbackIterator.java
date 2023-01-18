package edu.virginia.lib.sqsserver;

import java.util.Iterator;

/**
 * Decorates an iterator to support pushback of one single element.
 * <p>
 * The decorator stores the pushed back element in a member variable, if a second one is 
 * pushed back, before that one is used the first pushed-back item is quietly discarded
 * <p>
 * The decorator does not support the removal operation. Any call to {@link #remove()} will
 * result in an {@link UnsupportedOperationException}.
 *
 */
public class PushbackIterator<E> implements Iterator<E>
{
    /** The iterator being decorated. */
    private final Iterator<? extends E> iterator;

    /** the one item that has been pushed back */
    private E item = null;
    
    //-----------------------------------------------------------------------
    /**
     * Decorates the specified iterator to support one-element lookahead.
     * <p>
     * If the iterator is already a {@link PushbackIterator} it is returned directly.
     *
     * @param <E>  the element type
     * @param iterator  the iterator to decorate
     * @return a new peeking iterator
     * @throws NullPointerException if the iterator is null
     */
    public static <E> PushbackIterator<E> pushbackIterator(final Iterator<? extends E> iterator)
    {
        if (iterator == null)
        {
            throw new NullPointerException("Iterator must not be null");
        }
        if (iterator instanceof PushbackIterator<?>)
        {
            @SuppressWarnings("unchecked") // safe cast
            final PushbackIterator<E> it = (PushbackIterator<E>) iterator;
            return it;
        }
        return new PushbackIterator<>(iterator);
    }

    //-----------------------------------------------------------------------

    /**
     * Constructor.
     *
     * @param iterator  the iterator to decorate
     */
    public PushbackIterator(final Iterator<? extends E> iterator)
    {
        super();
        this.iterator = iterator;
    }

    /**
     * Push back the given element to the iterator.
     * <p>
     * Calling {@link #next()} immediately afterwards will return exactly this element.
     *
     * @param item  the element to push back to the iterator
     */
    public void pushback(final E item)
    {
        this.item = item;
    }

    @Override
    public boolean hasNext()
    {
        return item != null || iterator.hasNext();
    }

    @Override
    public E next()
    {
        if (item != null)
        {
            E tmpItem = item;
            item = null;
            return(tmpItem);
        }
        else
        {
            return iterator.next();
        }
    }

    /**
     * This iterator will always throw an {@link UnsupportedOperationException}.
     *
     * @throws UnsupportedOperationException always
     */
    @Override
    public void remove() {
        throw new UnsupportedOperationException();
    }
    
}
